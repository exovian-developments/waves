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

MSG="⚡ CAMBIO EN BLUEPRINT DETECTADO — PROYECCIÓN DE IMPACTOS OBLIGATORIA\n\nSe modificó el blueprint del producto. Antes de continuar, analiza el impacto en cascada:\n\n1. Lee el blueprint modificado e identifica QUÉ cambió\n2. Lee los roadmaps activos:$ROADMAP_LIST\n3. Lee las bitácoras activas:$LOGBOOK_LIST\n4. Lee los recent_context de cada bitácora\n\nProyecta y COMPARTE CON EL USUARIO:\n- ¿Qué fases del roadmap se ven afectadas por este cambio?\n- ¿Qué objetivos en curso contradicen o se desalinean con el cambio?\n- ¿Hay capacidades nuevas sin soporte en ningún roadmap?\n- ¿Hay decisiones ya tomadas (en bitácoras) que ahora son inválidas?\n- ¿Qué bitácoras necesitan ajuste inmediato?\n- ¿Qué riesgos introduce este cambio para el trabajo en curso?\n\nSé específico. Referencia capacidades por ID, fases por número, objetivos por ID."

jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
