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
  echo "Waves: Este proyecto tiene blueprint pero no tiene roadmap. Crea uno antes de implementar: /waves:roadmap-create" >&2
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
  echo "Waves: Este proyecto tiene blueprint y roadmap pero no tiene bitácora. Crea una para tu tarea: /waves:logbook-create" >&2
  exit 2
fi

# --- All artifacts present: allow + inject classification reminder ---
REMINDER="CLASIFICA tu decisión antes de actuar:\n- Nivel 1-2 (implementación técnica) → Procede. Documenta en bitácora.\n- Nivel 3 (fuera del scope del objetivo) → PARA. Consulta al usuario.\n- Nivel 4 (afecta una capacidad del blueprint) → PARA. Presenta escenarios.\n- Nivel 5 (descubrimiento con valor propio) → PARA. Proyecta y asesora."

jq -n --arg ctx "$REMINDER" '{"additionalContext": $ctx}'
