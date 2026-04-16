<div align="center">

# Waves™

**[English](README.md) | [Español](README.es.md) | [Português](README.pt.md)**

*El Product Consciousness Framework para la era de los agentes IA*

</div>

## Por qué Waves

El desarrollo de productos como lo conocíamos cambió. Los agentes IA (Claude Code, Codex, Gemini CLI) comprimen lo que antes tomaba 6 meses de desarrollo en días o semanas. Los sprints de 2 semanas ya no reflejan el ritmo real del trabajo — el desarrollo ya no es el cuello de botella.

Pero hay un problema más profundo: **tu agente IA no tiene criterio.** Trata igual renombrar una variable que cambiar tu modelo de negocio. No sabe cuándo avanzar y cuándo detenerse. Sin clasificación no hay confianza — y sin confianza no puedes delegar de verdad.

Waves reemplaza los sprints fijos por **olas**: ciclos orgánicos de duración variable donde cada ola lleva un incremento de producto desde la validación hasta producción. Y con **Waves 2.0**, el agente se convierte en un asesor estratégico con autonomía graduada — conoce tu negocio, aplica tus reglas mecánicamente, clasifica cada decisión por nivel de impacto, y te alerta sobre lo que no puedes ver porque estás enfocado en la tarea inmediata.

## Qué es

Waves es un Product Consciousness Framework que le da al **equipo humano + IA**:

1. **Estructura** — qué artefactos existen y cómo se relacionan
2. **Orden** — en qué secuencia se produce valor
3. **Memoria** — persistencia estructurada entre sesiones y agentes
4. **Governance** — cumplimiento mecánico que no se degrada
5. **Confianza** — autonomía graduada por nivel de decisión
6. **Percepción extendida** — el agente ve todo el tablero mientras tú te enfocas en la pieza

Funciona con `Claude Code` (funcionalidad completa 2.0), `Claude Desktop` (plugin), `Codex` y `Gemini CLI` mediante comandos interactivos y schemas JSON estructurados.

### El Ciclo de Vida del Producto

Waves organiza el trabajo en cinco niveles, donde cada uno se construye sobre el anterior:

**1. Factibilidad** → *¿Podemos construir esto? ¿Deberíamos?*
Describes tu idea en lenguaje natural. El agente actúa como consultor de negocios: analiza el mercado, identifica competidores, construye proyecciones de ingresos con simulaciones Monte Carlo, y te da números honestos sobre si esto puede funcionar. El resultado es un análisis de factibilidad con datos reales — no opiniones.

**2. Foundation** → *¿Qué aprendimos?*
La factibilidad puede producir miles de simulaciones en múltiples escenarios. El foundation compacta todo en un resumen ejecutivo limpio: el problema validado, quiénes son tus usuarios, el modelo de ingresos con unit economics, análisis SWOT, capacidades esenciales, restricciones de timeline, y una señal clara de go/no-go. Este es el puente entre la investigación y la definición del producto.

**3. Blueprint** → *¿Qué estamos construyendo y por qué?*
Usando el foundation como input, defines el producto: sus capacidades (qué pueden hacer los usuarios), los flujos de usuario (cómo lo hacen), principios de diseño, reglas de producto, métricas de éxito y stack tecnológico. Cada sección conecta con el caso de negocio. Nada especulativo — cada capacidad traza a un flujo de ingresos, cada regla traza a un principio.

**4. Roadmap** → *¿Cuándo lo construimos y en qué orden?*
El roadmap toma las capacidades del blueprint y las organiza en fases con milestones, dependencias y puntos de decisión. Responde preguntas como: ¿qué va en el MVP? ¿Qué puede esperar? ¿Qué bloquea qué?

**5. Logbook** → *¿Cómo implementamos esta pieza específica?*
Para cada ticket o tarea, un logbook desglosa el trabajo en objetivos principales y secundarios con guías de completado. El agente los implementa continuamente, actualiza el progreso en tiempo real, y preserva el contexto completo entre sesiones para que no se pierda conocimiento.

```
factibilidad → foundation → blueprint → roadmap → logbook
 ¿PODEMOS?    ¿QUÉ          ¿QUÉ/POR   ¿CUÁNDO?  ¿CÓMO?
              APRENDIMOS?    QUÉ?
```

Cada nivel alimenta al siguiente. Puedes empezar en cualquier nivel — si ya tienes un producto y solo necesitas logbooks para el trabajo diario, empieza ahí. El pipeline completo es para cuando construyes algo desde cero.

### Qué hay de nuevo en 2.0

Waves 1.x le dio estructura al caos. **Waves 2.0 le da consciencia a la estructura.**

| Capacidad | Qué hace | Cómo funciona |
|-----------|----------|---------------|
| **Percepción** | El agente inicia cada sesión conociendo el estado completo del producto | Hook SessionStart lee artefactos, inyecta resumen de estado + fuerza lectura de blueprint, roadmap, logbook |
| **Cumplimiento mecánico** | Reglas que no se pueden ignorar | Hook PreToolUse bloquea acciones (exit 2) cuando faltan blueprint/roadmap/logbook |
| **Clasificación de decisiones** | Autonomía graduada en 5 niveles | Recordatorio de clasificación inyectado en cada acción, re-inyectado después de compactación |
| **Metacognición proactiva** | El agente reflexiona en momentos estratégicos | Hooks PostToolUse se disparan al completar objetivos, cambios en blueprint, completar fases |
| **Supervivencia de contexto** | Las reglas sobreviven sesiones largas | SessionStart se re-dispara después de compactación de contexto, re-inyectando estado y reglas |
| **Governance graduada** | Cumplimiento proporcional a la madurez | Sin blueprint → permite todo; blueprint sin roadmap → bloquea; artefactos completos → permite + clasifica |

**Clasificación de decisiones — El contrato de confianza:**

| Nivel | Tipo | Acción del agente |
|-------|------|-------------------|
| 1 | Mecánica (nombres, formato) | Procede en silencio |
| 2 | Técnica (patrón, estructura) | Procede + documenta en logbook |
| 3 | Alcance (fuera del objetivo actual) | **SE DETIENE.** Informa. Espera. |
| 4 | Negocio (afecta capacidad del blueprint) | **SE DETIENE.** Proyecta escenarios. Espera. |
| 5 | Descubrimiento (valor de mercado independiente) | **SE DETIENE.** Documenta. Proyecta. Asesora. |

> En caso de duda, el agente clasifica **HACIA ARRIBA** (más cautela), nunca hacia abajo. Validado con 18 escenarios benchmark: 100% acciones correctas.

**Disponibilidad por plataforma:** Las funcionalidades completas de 2.0 (hooks, enforcement, metacognición) requieren Claude Code. Las funcionalidades basadas en schemas (artefactos, persistencia, comandos) funcionan en todas las plataformas.

### Tres formas de usarlo

1. **Plugin Cowork (Recomendado)** — Instala el plugin en Claude desktop para la experiencia completa con GUI
2. **Slash Commands** — Comandos interactivos para Claude Code CLI
3. **Prompts Manuales** — Copia/pega prompts para generar archivos desde los schemas

### Cómo funcionan los schemas

Cada JSON schema usa un patrón de doble instrucción:

- `description` = Qué representa el campo, para que la LLM entienda qué contenido generar
- `$comment` = Cómo la LLM debe operar ese campo, mejorando la precisión y consistencia

---

## Características

| Característica | Descripción |
|----------------|-------------|
| **Percepción** | El agente inicia cada sesión informado — estado del producto, wave activa, fase actual, siguiente objetivo |
| **Cumplimiento** | Hooks mecánicos que bloquean acciones cuando faltan artefactos — no sugerencias, código |
| **Clasificación** | Autonomía de decisión en 5 niveles — el agente sabe cuándo avanzar y cuándo detenerse |
| **Metacognición** | Reflexión proactiva al completar objetivos, cambios en blueprint y completar fases |
| **Multi-Agente** | Los mismos archivos funcionan con Claude Code, Claude Desktop, Codex y Gemini CLI |
| **Multi-Sesión** | Logbooks + hooks preservan contexto entre sesiones y después de compactación |
| **Software + General** | Soporta proyectos de software Y académicos, creativos, de negocio |
| **Validación de Negocio** | Análisis de factibilidad con simulaciones Monte Carlo antes de escribir una línea de código |

---

## Inicio Rápido (Plugin Cowork)

### Instalar

Descarga `waves.plugin` de [Releases](https://github.com/exovian-developments/waves/releases) y doble clic para instalar en Claude desktop. O compila desde código:

```bash
cd plugin/
zip -r ../waves.plugin . -x "*.DS_Store"
```

### Uso

El plugin auto-carga el contexto del proyecto al iniciar sesión. Usa los comandos:

```
/project-init          # Inicializar preferencias y contexto
/manifest-create       # Analizar proyecto y crear manifiesto
/logbook-create        # Crear logbook con objetivos
/logbook-update        # Registrar progreso en objetivos
```

El plugin delega el trabajo de análisis a 16 agentes especializados, manteniendo el hilo principal liviano para sesiones de trabajo largas.

Ver [`plugin/README.md`](plugin/README.md) para documentación completa del plugin.

---

## Inicio Rápido (Claude Code)

### 1. Instalar

**Opción A: Homebrew (recomendado)**

```bash
brew tap exovian-developments/waves
brew install waves

# Inicializar en tu proyecto
cd your-project
waves init claude
```

**Opción B: Manual**

```bash
# Clonar el repositorio
git clone https://github.com/exovian-developments/waves.git

# Copiar a tu proyecto
mkdir -p your-project/.claude/{commands,hooks}
cp -r waves/.claude/commands/* your-project/.claude/commands/
cp waves/.claude/hooks/*.sh your-project/.claude/hooks/
chmod +x your-project/.claude/hooks/*.sh
cp waves/.claude/settings.json your-project/.claude/settings.json
mkdir -p your-project/ai_files/schemas
cp waves/schemas/*.json your-project/ai_files/schemas/
```

**Actualizar un proyecto existente:**

```bash
# Con Homebrew:
brew upgrade waves
cd your-project && waves update

# O desde clon local:
cd your-project
/path/to/waves/bin/waves update
```

### 2. Inicializar

En Claude Code, ejecuta:
```
/waves:project-init
```

Esto va a:
- Preguntar tu idioma preferido (English, Español, Português, etc.)
- Configurar tus preferencias de interacción
- Establecer el contexto del proyecto (software vs general, nivel de familiaridad)
- Crear `ai_files/user_pref.json`

### 3. Crear Manifiesto del Proyecto

```
/waves:manifest-create
```

Esto analizará tu proyecto y creará un manifiesto completo con tecnologías, arquitectura, features y recomendaciones.

### 4. Empezar a Trabajar con Logbooks

```
/waves:logbook-create TICKET-123.json
```

Crea un logbook estructurado con objetivos y guías de completado para tu ticket/tarea.

```
/waves:logbook-update TICKET-123.json
```

Actualiza progreso, cambia estados de objetivos, agrega nuevos objetivos descubiertos durante el trabajo.

---

## Comandos Disponibles

| Comando | Descripción | Estado |
|---------|-------------|--------|
| `/waves:project-init` | Inicializar preferencias y contexto | 🟢 Listo |
| `/waves:manifest-create` | Analizar proyecto y crear manifiesto | 🟢 Listo |
| `/waves:manifest-update` | Actualizar manifiesto con cambios | 🟢 Listo |
| `/waves:rules-create` | Extraer reglas de codificación | 🟢 Listo |
| `/waves:rules-update` | Actualizar reglas por cambios en código | 🟢 Listo |
| `/waves:user-pref-create` | Crear preferencias de usuario detalladas | 🟢 Listo |
| `/waves:user-pref-update` | Editar preferencias existentes | 🟢 Listo |
| `/waves:logbook-create` | Crear logbook de desarrollo | 🟢 Listo |
| `/waves:logbook-update` | Actualizar logbook con progreso | 🟢 Listo |
| `/waves:resolution-create` | Generar documento de resolución | 🟢 Listo |
| `/waves:objectives-implement` | Implementar objetivos con auditoría | 🟢 Listo |
| `/waves:roadmap-create` | Crear roadmap con fases y milestones | 🟢 Listo |
| `/waves:roadmap-update` | Actualizar progreso y decisiones del roadmap | 🟢 Listo |
| `/waves:feasibility-analyze` | Análisis de factibilidad con Monte Carlo y proyecciones Bayesian | 🟢 Listo |
| `/waves:foundation-create` | Compactar factibilidad en hechos validados y benchmarks financieros | 🟢 Listo |
| `/waves:blueprint-create` | Crear blueprint completo desde foundation con validación del owner | 🟢 Listo |

**Leyenda:** 🟢 Listo

---

## Schemas

| Schema | Propósito | Tipo de Proyecto |
|--------|-----------|------------------|
| `user_pref_schema.json` | Preferencias de interacción | Ambos |
| `software_manifest_schema.json` | Estructura y tecnología del proyecto | Software |
| `general_manifest_schema.json` | Estructura de proyecto no-software | General |
| `project_rules_schema.json` | Reglas y patrones de codificación | Software |
| `project_standards_schema.json` | Estándares para proyectos generales | General |
| `logbook_software_schema.json` | Logbook con refs de código | Software |
| `logbook_general_schema.json` | Logbook con refs de documentos | General |
| `ticket_resolution_schema.json` | Resumen de cierre de ticket | Software |
| `logbook_roadmap_schema.json` | Roadmap con fases y milestones | Ambos |
| `feasibility_analysis_schema.json` | Análisis de factibilidad con proyecciones | Ambos |
| `product_foundation_schema.json` | Puente factibilidad → blueprint | Ambos |

---

## Estructura del Proyecto

Después de la instalación, tu proyecto tendrá:

```
your-project/
├── .claude/
│   ├── settings.json               # Configuración de hooks (Waves 2.0)
│   ├── commands/                    # Slash commands
│   │   ├── waves:project-init.md
│   │   ├── waves:blueprint-create.md
│   │   ├── waves:roadmap-create.md
│   │   ├── waves:logbook-create.md
│   │   └── ... (16 comandos en total)
│   └── hooks/                       # Hooks ejecutables (Waves 2.0)
│       ├── waves-perceive.sh        # SessionStart: inyecta estado del producto
│       ├── waves-gate.sh            # PreToolUse: cumplimiento graduado
│       ├── waves-doc-enforce.sh     # PostToolUse: cumplimiento de documentación
│       ├── waves-metacognition.sh   # PostToolUse: disparadores de reflexión
│       ├── waves-blueprint-impact.sh # PostToolUse: proyección de impacto
│       ├── waves-phase-audit.sh     # PostToolUse: auditoría estratégica
│       └── waves-dart-analyze.sh    # PostToolUse: análisis dart
├── ai_files/
│   ├── schemas/                     # JSON schemas
│   ├── user_pref.json               # Tus preferencias
│   ├── project_manifest.json        # Análisis del proyecto
│   ├── project_rules.json           # Reglas de codificación
│   ├── blueprint.json               # Definición del producto (QUÉ/POR QUÉ)
│   └── waves/
│       └── wN/
│           ├── roadmap.json         # Plan de la wave (CUÁNDO/ORDEN)
│           └── logbooks/            # Implementación (CÓMO/DETALLE)
└── CLAUDE.md                        # Protocolo Operativo del Agente
```

---

## Flujo de Trabajo

### Para Proyectos de Software

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │  rules-create   │
│ (preferencias)  │     │(analizar proyecto)│     │ (extraer reglas)│
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                          │
         ┌────────────────────────────────────────────────┘
         ▼
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ logbook-create  │ ──▶ │  logbook-update  │ ──▶ │resolution-create│
│  (nuevo ticket) │     │(registrar avance)│     │ (cerrar ticket) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

### Para Proyectos Generales (Académicos, Creativos, Negocio)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  project-init   │ ──▶ │ manifest-create  │ ──▶ │ logbook-create  │
│ (preferencias)  │     │(definir proyecto)│     │(registrar tareas)│
└─────────────────┘     └──────────────────┘     └─────────────────┘
```

---

## Flujos de Creación de Manifiesto

El comando `manifest-create` se adapta a tu proyecto:

### Proyectos de Software
- **A1: Proyecto Nuevo** - 5 preguntas para definir stack y features
- **A2.1: Existente (Conocido)** - 2 checkpoints + 6 analizadores paralelos
- **A2.2: Existente (Desconocido)** - Cero preguntas, análisis completo con prints de progreso

### Proyectos Generales
- **B1: Académico** - Tema de investigación, metodología, milestones, citas
- **B2: Creativo** - Concepto, estilo, assets, entregables
- **B3: Negocio** - 9 preguntas de Business Model Canvas
- **B4: Otro** - Objetivos y entregables genéricos
- **BE: Existente** - Descubrimiento de directorios y análisis de contenido

---

## Subagentes Especializados

Los comandos usan 33 subagentes especializados:

| Categoría | Subagentes | Estado |
|-----------|------------|--------|
| **Core** | project-initializer, manifest-creator-new-software, secondary-objective-generator, context-summarizer | ✅ Completo |
| **Análisis de Software** | entry-point-analyzer, navigation-mapper, flow-tracker, dependency-auditor, architecture-detective, feature-extractor | ✅ Completo |
| **Proyectos Generales** | manifest-creator-academic/creative/business/generic, general-project-scanner, directory-analyzer | ✅ Completo |
| **Reglas** | pattern-extractor, convention-detector, antipattern-detector, criteria-validator, standards-structurer | ✅ Completo |
| **Actualizaciones** | git-history-analyzer, autogen-detector, manifest-change-analyzer, timestamp-analyzer, manifest-updater, rule-comparator | ✅ Completo |
| **Implementación** | code-implementer, code-auditor | ✅ Completo |
| **Roadmap** | roadmap-creator, roadmap-updater | ✅ Completo |

Ver [subagents/README.md](subagents/README.md) para detalles completos.

---

## Instalación Manual (Alternativa)

Si prefieres no usar slash commands, puedes usar los schemas directamente:

### 1. Configuración

```bash
git clone https://github.com/exovian-developments/waves.git
cd your-project
mkdir -p ai_files/schemas .claude/{commands,hooks}
cp waves/schemas/*.json ai_files/schemas/
cp waves/.claude/commands/*.md .claude/commands/
cp waves/.claude/hooks/*.sh .claude/hooks/ && chmod +x .claude/hooks/*.sh
cp waves/.claude/settings.json .claude/settings.json
```

### 2. Agregar a CLAUDE.md

```markdown
# Key files to review on session start:
required_reading:
  - path: "ai_files/project_manifest.json"
    description: "Project structure, technologies, architecture"
    when: "always"

  - path: "ai_files/project_rules.json"
    description: "Coding rules and conventions to follow"
    when: "always"

  - path: "ai_files/user_pref.json"
    description: "User interaction preferences"
    when: "always"

  - path: "ai_files/logbooks/"
    description: "Development logbooks for tickets"
    when: "always"
```

### 3. Usar Prompts

**Crear Preferencias de Usuario:**
```
Analyze ai_files/schemas/user_pref_schema.json and ask me questions to generate ai_files/user_pref.json. Be concise and follow the schema structure.
```

**Crear Manifiesto del Proyecto:**
```
Analyze ai_files/schemas/software_manifest_schema.json, then analyze this project thoroughly (all directories and files). Generate ai_files/project_manifest.json following the schema.
```

**Crear Logbook:**
```
Analyze ai_files/schemas/logbook_software_schema.json. Based on the ticket I'll describe, create a logbook with objectives and completion guides.
```

---

## Estructura del Logbook

Cada logbook contiene:

```json
{
  "ticket": {
    "title": "Implement GET /products/:id endpoint",
    "url": "https://jira.company.com/PROJ-123",
    "description": "Full ticket details..."
  },
  "objectives": {
    "main": [
      {
        "id": 1,
        "content": "Endpoint returns product with specifications",
        "context": "Frontend needs complete data for detail page",
        "scope": {
          "files": ["src/controllers/ProductController.ts"],
          "rules": [3, 7]
        },
        "status": "active"
      }
    ],
    "secondary": [
      {
        "id": 1,
        "content": "ProductDetailDTO includes specifications array",
        "completion_guide": [
          "Use pattern from src/dtos/BaseDTO.ts:12",
          "Apply rule #3: @Expose() decorators"
        ],
        "status": "not_started"
      }
    ]
  },
  "recent_context": [
    {
      "id": 1,
      "created_at": "2025-12-11T10:00:00Z",
      "content": "Logbook created. Ready to start."
    }
  ],
  "history_summary": [],
  "future_reminders": []
}
```

**Valores de status:** `not_started`, `active`, `blocked`, `achieved`, `abandoned`

---

## Convenciones

- **IDs:** Entero empezando en 1, inmutable una vez creado
- **Timestamps:** UTC ISO 8601, `created_at` inmutable
- **Límite de contexto:** 20 entradas recientes, auto-compacta a history_summary
- **Límite de historial:** 10 resúmenes máximo
- **YAGNI:** Todas las guías de completado aplican el principio YAGNI

---

## Validación

```bash
# Node (AJV)
npx ajv validate -s ai_files/schemas/logbook_software_schema.json -d ai_files/logbooks/TICKET-123.json

# Python
python -c "import json,jsonschema; jsonschema.validate(json.load(open('data.json')), json.load(open('schema.json')))"
```

---

## Estructura del Repositorio

```
waves/
├── bin/waves             # Instalador CLI (brew install waves)
├── schemas/              # Fuente de verdad: JSON schemas
├── .claude/
│   ├── commands/         # 16 slash commands ejecutables
│   ├── hooks/            # 7 hooks Waves 2.0 (perceive, gate, enforce, metacognition, ...)
│   └── settings.json     # Configuración de hooks (SessionStart, PreToolUse, PostToolUse)
├── plugin/               # Plugin Cowork (Claude Desktop)
│   ├── agents/           # Agentes especializados
│   ├── commands/         # Slash commands
│   ├── skills/           # Conocimiento del protocolo + refs de schemas
│   └── hooks/            # Hook SessionStart basado en prompt
├── subagents/            # Diseño canónico: especificaciones de subagentes
├── commands/             # Documentos de diseño de comandos (numerados, detallados)
├── FRAMEWORK.md          # Documentación completa del framework (v2.0)
├── CHANGELOG.md          # Historial de versiones
└── README.md
```

---

## Compatibilidad

| Plataforma | Hooks (2.0) | Plugin | Slash Commands | Prompts Manuales |
|------------|-------------|--------|---------------|------------------|
| Claude Code | ✅ Completo (enforcement, metacognición, clasificación) | ❌ | ✅ | ✅ |
| Claude Desktop | ❌ | ✅ (percepción basada en prompt) | ✅ | ✅ |
| Codex | ❌ | ❌ | ❌ | ✅ |
| Gemini CLI | ❌ | ❌ | ❌ | ✅ |

**Nota:** Las funcionalidades basadas en hooks (cumplimiento mecánico, metacognición, clasificación de decisiones) son actualmente exclusivas de Claude Code. Las funcionalidades basadas en schemas (artefactos, persistencia, comandos) funcionan en todas las plataformas.

---

## Licencia

- Código y schemas: AGPL-3.0-or-later (ver `LICENSE`)
- Documentación: CC BY 4.0 (opcional)

---

## Contribuir

Ver [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) para detalles de arquitectura y [subagents/README.md](subagents/README.md) para estado de implementación.

**Prioridades actuales:**
1. Feedback de la comunidad sobre los niveles de clasificación de decisiones
2. Soporte de hooks para plataformas adicionales (Codex, Gemini CLI) si se solicita
3. Mantener agentes del plugin sincronizados con cambios canónicos de subagentes
