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

  # List logbooks in this wave
  LOGBOOK_LIST=""
  if [ -d "$AI_FILES/waves/$WAVE/logbooks" ]; then
    for lb in "$AI_FILES/waves/$WAVE/logbooks/"*.json; do
      [ -f "$lb" ] || continue
      LOGBOOK_LIST="$LOGBOOK_LIST\n- $(basename "$lb")"
    done
  fi

  MSG="🏁 FASE DE ROADMAP COMPLETADA — AUDITORÍA ESTRATÉGICA OBLIGATORIA\n\nSe completó una fase del roadmap ($WAVE). Realiza un análisis estratégico completo.\n\nLee:\n1. ai_files/blueprint.json — el producto completo\n2. $FILE — la fase completada y las siguientes\n3. Todas las bitácoras de la fase completada:$LOGBOOK_LIST\n4. Todos los recent_context acumulados\n5. Las decisiones registradas en el roadmap\n\nProduce un análisis que incluya:\n- Resumen de la fase: milestones cumplidos, objetivos resueltos, decisiones tomadas\n- Estado de alineamiento con el blueprint: ¿qué capacidades avanzaron?\n- Descubrimientos: patrones, herramientas, o soluciones que emergieron con valor propio\n- Riesgos para la siguiente fase: dependencias, bloqueos, asunciones que podrían fallar\n- Oportunidades detectadas: ¿algo de esta fase es replicable o comercializable?\n- Recomendaciones: ¿qué debería ajustarse antes de iniciar la siguiente fase?\n- Preguntas abiertas: ¿quedó algo sin resolver que afecta lo que viene?\n\nSé específico y referencia artefactos por ID/nombre."

  jq -n --arg ctx "$MSG" '{"additionalContext": $ctx}'
  exit 0
fi

echo '{}'
exit 0
