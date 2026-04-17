#!/bin/bash
# waves-phase-audit.sh — PostToolUse hook for Waves 2.0
# Triggers strategic audit when a roadmap phase is completed.
#
# Detects: edit to */roadmap.json where a phase status changed to "completed"/"achieved"
# Action: injects additionalContext prompting comprehensive strategic analysis
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for strategic audit prompt

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a roadmap file
if [[ "$FILE" != */roadmap.json ]]; then
  echo '{}'
  exit 0
fi

# Quick exit: file doesn't exist
if [ ! -f "$FILE" ]; then
  echo '{}'
  exit 0
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo '{}'
  exit 0
fi

# Count completed phases
PHASES_COMPLETED=$(jq '[.phases[] | select(.status == "completed" or .status == "achieved")] | length' "$FILE" 2>/dev/null || echo 0)

# Read marker to detect change
MARKER_DIR="/tmp/waves-phase-audit"
mkdir -p "$MARKER_DIR" 2>/dev/null
MARKER_FILE="$MARKER_DIR/$(echo "$FILE" | md5 2>/dev/null || echo "$FILE" | md5sum 2>/dev/null | cut -d' ' -f1)"
LAST_COUNT=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)

# Update marker
echo "$PHASES_COMPLETED" > "$MARKER_FILE"

# If count increased, a phase was just completed
if [ "$PHASES_COMPLETED" -gt "$LAST_COUNT" ]; then
  # Get the wave name from path
  WAVE=$(echo "$FILE" | sed 's|.*/waves/\([^/]*\)/roadmap.json|\1|')

  # Resolve project root
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
  AI_FILES="$PROJECT_DIR/ai_files"

  # Write pending marker — gate blocks until delegation
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "/tmp/waves-metacognition-pending"

  # Read metacognition model from user_pref.json (default: opus)
  META_MODEL="opus"
  for pref in "$AI_FILES/user_pref.json" "user_pref.json"; do
    if [ -f "$pref" ]; then
      CONFIGURED_MODEL=$(jq -r '.agent_config.metacognition_model // empty' "$pref" 2>/dev/null)
      [ -n "$CONFIGURED_MODEL" ] && META_MODEL="$CONFIGURED_MODEL"
      break
    fi
  done

  # Find blueprint
  BP=""
  for bp in "$AI_FILES/blueprint.json" "$AI_FILES/product_blueprint.json"; do
    [ -f "$bp" ] && BP="$bp" && break
  done

  # ALL roadmaps (not just this wave — other waves may be affected)
  ALL_ROADMAPS=""
  for rm in "$AI_FILES"/waves/*/roadmap.json; do
    [ -f "$rm" ] || continue
    ALL_ROADMAPS="$ALL_ROADMAPS\n- $rm"
  done
  ROADMAPS_PATHS=$(echo -e "$ALL_ROADMAPS" | grep -v '^$')

  # ALL logbooks (not just this wave)
  ALL_LOGBOOKS=""
  for lb in "$AI_FILES"/waves/*/logbooks/*.json; do
    [ -f "$lb" ] || continue
    ALL_LOGBOOKS="$ALL_LOGBOOKS\n- $lb"
  done
  LOGBOOKS_PATHS=$(echo -e "$ALL_LOGBOOKS" | grep -v '^$')

  MSG="METACOGNITION — Phase completed in $WAVE. BLOCKED until you delegate.\n\nDo this NOW:\n1. Spawn background Agent (run_in_background=true, model=$META_MODEL) — COPY THE PROMPT BELOW EXACTLY. Do NOT rewrite, shorten, or paraphrase it.\n2. Write to any ai_files/ artifact — this clears the gate.\n\nWhen subagent returns: CRITICAL → stop and present. No findings → note and continue.\n\nPROMPT (copy as-is into the Agent prompt parameter):\nPhase completed in $WAVE. Read ALL these files completely:\n${BP:-blueprint not found}\n$ROADMAPS_PATHS\n$LOGBOOKS_PATHS\n\nThe team is about to start the next phase. Your job is to ensure it starts on solid ground.\n1. READINESS: does the next phase have all prerequisites? Missing accounts, APIs, infrastructure, design assets, legal? Decisions from completed phase that must be resolved first? Abandoned logbook objectives the next phase depends on? Ambiguities in next phase milestones?\n2. ALIGNMENT: which blueprint capabilities advanced? Any falling behind or diverging from design? Do design principles still hold? Is the product hypothesis still supported?\n3. OPPORTUNITIES: can phases be reordered for parallel work? Reusable patterns from this phase? Faster path to the hypothesis? Capabilities to descope based on learnings?\n\nReference capability IDs, phase numbers, objective IDs. Start with CRITICAL: if findings, or 'No critical findings. Phase $WAVE audit complete.' if none. Under 400 words."

  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
