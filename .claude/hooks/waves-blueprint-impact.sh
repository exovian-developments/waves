#!/bin/bash
# waves-blueprint-impact.sh — PostToolUse hook for Waves 2.0
# Triggers impact projection when the product blueprint is modified.
#
# This is the MOST IMPORTANT metacognition trigger.
# When the blueprint changes, everything downstream is potentially affected.
#
# Detects: edit to ai_files/blueprint.json or ai_files/product_blueprint.json
# Action: injects additionalContext prompting the agent to project cascading impacts
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for impact projection prompt

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a blueprint file
case "$FILE" in
  */blueprint.json|*/product_blueprint.json)
    # Proceed — this is a blueprint
    ;;
  *)
    echo '{}'
    exit 0
    ;;
esac

# Resolve project root
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"

# Build context about what roadmaps and logbooks exist
ROADMAP_LIST=""
LOGBOOK_LIST=""

for roadmap in "$AI_FILES"/waves/*/roadmap.json; do
  [ -f "$roadmap" ] || continue
  WAVE=$(echo "$roadmap" | sed 's|.*/waves/\([^/]*\)/roadmap.json|\1|')
  ROADMAP_LIST="$ROADMAP_LIST\n- $WAVE: $roadmap"
done

for logbook in "$AI_FILES"/waves/*/logbooks/*.json; do
  [ -f "$logbook" ] || continue
  LOGBOOK_LIST="$LOGBOOK_LIST\n- $logbook"
done

# Read metacognition model from user_pref.json (default: opus)
META_MODEL="opus"
for pref in "$AI_FILES/user_pref.json" "user_pref.json"; do
  if [ -f "$pref" ]; then
    CONFIGURED_MODEL=$(jq -r '.agent_config.metacognition_model // empty' "$pref" 2>/dev/null)
    [ -n "$CONFIGURED_MODEL" ] && META_MODEL="$CONFIGURED_MODEL"
    break
  fi
done

# Write pending marker — gate blocks until delegation
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "/tmp/waves-metacognition-pending"

# Build clean path lists for the subagent (one per line with - prefix)
ROADMAPS_PATHS=$(echo -e "$ROADMAP_LIST" | grep -v '^$')
LOGBOOKS_PATHS=$(echo -e "$LOGBOOK_LIST" | grep -v '^$')

MSG="METACOGNITION — Blueprint changed. BLOCKED until you delegate.\n\nDo this NOW:\n1. Spawn background Agent (run_in_background=true, model=$META_MODEL) — COPY THE PROMPT BELOW EXACTLY. Do NOT rewrite, shorten, or paraphrase it. The analysis quality depends on the exact prompt.\n2. Write to any ai_files/ artifact — this clears the gate.\n\nWhen subagent returns: CRITICAL → stop and present. No findings → note and continue.\n\nPROMPT (copy as-is into the Agent prompt parameter):\nBlueprint impact analysis. Read ALL these files completely:\n$FILE\n$ROADMAPS_PATHS\n$LOGBOOKS_PATHS\n\nThe blueprint was just modified. Analyze holistically:\n1. INVALIDATED WORK: roadmap phases planning work on changed/removed capabilities? Logbook objectives that no longer match? Decisions in logbooks now contradicted? Completed work that needs revision?\n2. COVERAGE GAPS: new capabilities without roadmap coverage? New flows/views without logbook objectives? New dependencies not in phase ordering?\n3. OPPORTUNITIES: can phases be consolidated? Is planned work now unnecessary? Faster path to the product hypothesis?\n\nThink like a business advisor, not a code reviewer. Reference capability IDs, phase numbers, objective IDs. Start with CRITICAL: if findings, or 'No critical findings.' if none. Under 400 words."

jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
