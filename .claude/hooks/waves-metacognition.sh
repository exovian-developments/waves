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
  MSG="METACOGNICIÓN — Objetivo primario completado.\n\nAntes de continuar, lee el grafo completo:\n1. El blueprint: la capacidad o flujo que sustenta este objetivo.\n2. El roadmap: la fase actual y las siguientes.\n3. Todas las bitácoras activas (no solo esta): sus recent_context.\n\nReflexiona y COMPARTE CON EL USUARIO (esto es obligatorio):\n- ¿Qué aprendiste que cambia tu entendimiento del producto?\n- ¿Ves algún riesgo o bloqueo para los objetivos o fases que vienen?\n- ¿Encontraste algo con valor propio — un patrón, herramienta, o solución reutilizable que podría beneficiar al ecosistema? (Nivel 5)\n- ¿Hay desalineamiento entre lo que el blueprint promete y lo que la implementación revela?\n- ¿Qué le recomendarías al usuario que él no puede ver porque está enfocado en la tarea inmediata?\n\nNO avances al siguiente objetivo sin haber compartido esta reflexión."
  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
