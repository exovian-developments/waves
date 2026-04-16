#!/bin/bash
# waves-metacognition.sh — PostToolUse hook for Waves 2.0
# Triggers metacognition checkpoint when a primary objective is completed.
#
# Detects: edit to */logbooks/*.json where a main objective status changed to "achieved"/"completed"
# Action: injects additionalContext forcing the agent to reflect holistically before continuing
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} for metacognition prompt, empty otherwise

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Quick exit: not a logbook file
if [[ "$FILE" != *"/logbooks/"*.json ]]; then
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

# Check if any main objective was JUST completed
# (has status achieved/completed but no completed_at timestamp older than 60 seconds)
# Simple heuristic: count main objectives with "achieved" status
MAIN_COMPLETED=$(jq '[.objectives.main[] | select(.status == "achieved" or .status == "completed")] | length' "$FILE" 2>/dev/null || echo 0)

# Read a marker file to track last known count
MARKER_DIR="/tmp/waves-metacognition"
mkdir -p "$MARKER_DIR" 2>/dev/null
MARKER_FILE="$MARKER_DIR/$(echo "$FILE" | md5 2>/dev/null || echo "$FILE" | md5sum 2>/dev/null | cut -d' ' -f1)"
LAST_COUNT=$(cat "$MARKER_FILE" 2>/dev/null || echo 0)

# Update marker
echo "$MAIN_COMPLETED" > "$MARKER_FILE"

# If count increased, a main objective was just completed
if [ "$MAIN_COMPLETED" -gt "$LAST_COUNT" ]; then
  MSG="METACOGNITION — Primary objective completed.\n\nBefore continuing, read the full graph:\n1. The blueprint: the capability or flow that supports this objective.\n2. The roadmap: the current phase and the ones ahead.\n3. All active logbooks (not just this one): their recent_context.\n\nReflect and SHARE WITH THE USER (this is mandatory):\n- What did you learn that changes your understanding of the product?\n- Do you see any risk or blocker for upcoming objectives or phases?\n- Did you find something with independent value — a pattern, tool, or reusable solution that could benefit the ecosystem? (Level 5)\n- Is there misalignment between what the blueprint promises and what the implementation reveals?\n- What would you recommend to the user that they cannot see because they are focused on the immediate task?\n\nDo NOT proceed to the next objective without sharing this reflection."
  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
