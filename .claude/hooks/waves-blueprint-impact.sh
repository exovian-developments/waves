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
  LOGBOOK_LIST="$LOGBOOK_LIST\n- $(basename "$logbook")"
done

MSG="BLUEPRINT CHANGE DETECTED — MANDATORY IMPACT PROJECTION\n\nThe product blueprint was modified. Before continuing, analyze the cascading impact:\n\n1. Read the modified blueprint and identify WHAT changed\n2. Read the active roadmaps:$ROADMAP_LIST\n3. Read the active logbooks:$LOGBOOK_LIST\n4. Read each logbook's recent_context\n\nProject and SHARE WITH THE USER:\n- Which roadmap phases are affected by this change?\n- Which in-progress objectives contradict or misalign with the change?\n- Are there new capabilities without support in any roadmap?\n- Are there decisions already made (in logbooks) that are now invalid?\n- Which logbooks need immediate adjustment?\n- What risks does this change introduce for in-progress work?\n\nBe specific. Reference capabilities by ID, phases by number, objectives by ID."

jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
