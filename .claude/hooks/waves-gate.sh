#!/bin/bash
# waves-gate.sh — PreToolUse hook for Waves 2.0
# Implements graduated enforcement before every Edit/Write/Bash action.
#
# Logic:
#   No blueprint → allow everything (project in shaping phase)
#   Blueprint exists → Waves enforcement activates:
#     No roadmap → BLOCK (exit 2)
#     No logbook → BLOCK (exit 2)
#     All artifacts present → ALLOW + inject decision classification reminder
#
# Input: stdin JSON with {tool_name, tool_input} from PreToolUse event
# Output: JSON with {additionalContext} or exit 2 to block

set -euo pipefail

# Read stdin (PreToolUse event data)
INPUT=$(cat)

# Resolve project root
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
AI_FILES="$PROJECT_DIR/ai_files"

# If no ai_files directory, allow everything
if [ ! -d "$AI_FILES" ]; then
  echo '{}'
  exit 0
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo '{}'
  exit 0
fi

# --- Check Blueprint (the inflection point) ---
BLUEPRINT_EXISTS=false

if [ -f "$AI_FILES/blueprint.json" ] || [ -f "$AI_FILES/product_blueprint.json" ]; then
  BLUEPRINT_EXISTS=true
fi

# No blueprint = project in shaping phase → allow everything silently
if [ "$BLUEPRINT_EXISTS" = false ]; then
  echo '{}'
  exit 0
fi

# --- Blueprint exists: Waves enforcement activates ---

# Check for at least one roadmap
ROADMAP_EXISTS=false
for roadmap in "$AI_FILES"/waves/*/roadmap.json; do
  if [ -f "$roadmap" ]; then
    ROADMAP_EXISTS=true
    break
  fi
done

if [ "$ROADMAP_EXISTS" = false ]; then
  echo "Waves: This project has a blueprint but no roadmap. Create one before implementing: /waves:roadmap-create" >&2
  exit 2
fi

# Check for at least one logbook
LOGBOOK_EXISTS=false
for logbook in "$AI_FILES"/waves/*/logbooks/*.json; do
  if [ -f "$logbook" ]; then
    LOGBOOK_EXISTS=true
    break
  fi
done

if [ "$LOGBOOK_EXISTS" = false ]; then
  echo "Waves: This project has a blueprint and roadmap but no logbook. Create one for your task: /waves:logbook-create" >&2
  exit 2
fi

# --- All artifacts present: allow + inject classification reminder ---
REMINDER="CLASSIFY your decision before acting:\n- Level 1-2 (technical implementation) → Proceed. Document in logbook.\n- Level 3 (outside objective scope) → STOP. Inform user.\n- Level 4 (affects blueprint capability) → STOP. Project scenarios.\n- Level 5 (discovery with independent value) → STOP. Document. Advise."

jq -n --arg ctx "$REMINDER" '{"additionalContext": $ctx}'
