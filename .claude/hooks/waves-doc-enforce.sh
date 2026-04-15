#!/bin/bash
# waves-doc-enforce.sh — PostToolUse hook for Waves 2.0
# Ensures recent_context is updated when logbook objectives are completed.
#
# Only processes edits to logbook files (*/logbooks/*.json).
# For 99% of edits (non-logbook files), exits in <1ms.
#
# Uses a marker file to track the last known completed count.
# If completed count increased but recent_context didn't grow,
# documentation is missing.
#
# Input: stdin JSON with {tool_name, tool_input, tool_response} from PostToolUse
# Output: JSON with {additionalContext} if documentation is missing, empty otherwise

set -euo pipefail

# Read stdin
INPUT=$(cat)

# Extract file path from tool_input
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.content // empty' 2>/dev/null)

# Quick exit: not a logbook file → ignore (<1ms)
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

# Count objectives with status "achieved" or "completed" (main + secondary)
COMPLETED=$(jq '([.objectives.main[] | select(.status == "achieved" or .status == "completed")] | length) + ([.objectives.secondary[] | select(.status == "achieved" or .status == "completed")] | length)' "$FILE" 2>/dev/null || echo 0)

# Count recent_context entries
CONTEXT_ENTRIES=$(jq '.recent_context | length' "$FILE" 2>/dev/null || echo 0)

# Read marker to detect if completed grew without context growing
MARKER_DIR="/tmp/waves-doc-enforce"
mkdir -p "$MARKER_DIR" 2>/dev/null
FILE_HASH=$(echo "$FILE" | md5 2>/dev/null || echo "$FILE" | md5sum 2>/dev/null | cut -d' ' -f1)
MARKER_FILE="$MARKER_DIR/$FILE_HASH"

LAST_COMPLETED=$(cat "$MARKER_FILE.completed" 2>/dev/null || echo 0)
LAST_CONTEXT=$(cat "$MARKER_FILE.context" 2>/dev/null || echo 0)

# Update markers
echo "$COMPLETED" > "$MARKER_FILE.completed"
echo "$CONTEXT_ENTRIES" > "$MARKER_FILE.context"

# If completed count grew but context count didn't, documentation is missing
if [ "$COMPLETED" -gt "$LAST_COMPLETED" ] && [ "$CONTEXT_ENTRIES" -le "$LAST_CONTEXT" ]; then
  MSG="ENFORCEMENT: Marcaste objetivos como completados pero no agregaste una entrada en recent_context. Cada grupo de objetivos completados DEBE tener su contexto documentado — es la base para las proyecciones futuras y la continuidad entre sesiones. Agrega una entrada en recent_context describiendo qué se hizo y qué se aprendió."
  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
