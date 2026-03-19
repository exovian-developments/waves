# Command: `/waves:resolution-create [logbook]`

**Status:** ✅ DESIGNED

**Applies to:** Software projects only

---

## Overview

**Purpose:** Generate a resolution document from a software development logbook, documenting what was accomplished, code changes, and technical learnings.

**Schema:** `ai_files/schemas/ticket_resolution_schema.json`

**Input:** Logbook file (parameter or selection) - must be from a software project

**Output:** Resolution markdown file in `ai_files/waves/[wN]/resolutions/` (same wave as the source logbook)

**Parameters:** `[logbook]` (optional) - Logbook filename to use

**Note:** For general projects, the logbook itself serves as documentation. Use `/waves:logbook-update` to mark objectives as achieved and add final context entries.

---

## Flow

```
STEP 0: Determine which logbook to use

        IF parameter provided:
           └─ Use specified logbook: /waves:resolution-create mi-feature.json

        IF NO parameter:
           └─ Check if working on a logbook in current session
              ├─ IF yes → Confirm: "¿Usar logbook 'mi-feature.json'?"
              └─ IF no → List available logbooks

STEP 1: List logbooks (if needed)
        ┌─────────────────────────────────────────┐
        │ 📚 Bitácoras disponibles:               │
        │                                         │
        │ 1. auth-implementation.json (5 días)    │
        │ 2. payment-feature.json (2 días)        │
        │ 3. bug-fix-login.json (1 día)           │
        │                                         │
        │ Elige 1-3:                              │
        └─────────────────────────────────────────┘

STEP 2: Read and analyze logbook
        └─ Extract: objectives, findings, decisions, blockers resolved

STEP 3: Generate resolution document
        ┌─────────────────────────────────────────┐
        │ # Resolution: Auth Implementation       │
        │                                         │
        │ **Date:** 2024-11-25                    │
        │ **Duration:** 5 days                    │
        │ **Logbook:** auth-implementation.json   │
        │                                         │
        │ ## Summary                              │
        │ Implemented OAuth2 authentication...    │
        │                                         │
        │ ## Objectives Completed                 │
        │ - [x] User login with Google            │
        │ - [x] Session management                │
        │ - [x] Protected routes                  │
        │                                         │
        │ ## Key Decisions                        │
        │ - Used NextAuth.js over custom impl     │
        │ - JWT tokens stored in httpOnly cookies │
        │                                         │
        │ ## Challenges & Solutions               │
        │ 1. Token refresh issue → Added retry    │
        │                                         │
        │ ## Learnings                            │
        │ - NextAuth simplifies OAuth flow...     │
        │                                         │
        │ ## Files Modified                       │
        │ - src/auth/[...nextauth].ts            │
        │ - src/middleware.ts                     │
        └─────────────────────────────────────────┘

STEP 4: Show preview and confirm
        "¿Guardar esta resolución? (Si/No/Editar)"

STEP 5: Save file
        └─ ai_files/waves/[wN]/resolutions/auth-implementation-resolution.md
           (same wave as the source logbook — derive wN from the logbook path)

STEP 6: Success message
        "✅ Resolución creada!

         📁 Archivo: ai_files/waves/[wN]/resolutions/auth-implementation-resolution.md

         💡 Tip: Esta resolución servirá como referencia futura
         para problemas similares."
```

---

## Output Naming Convention

The resolution is saved in the **same wave** as the source logbook. Derive the wave from the logbook's path (e.g., if the logbook is at `ai_files/waves/w1/logbooks/auth-implementation.json`, the resolution goes to `ai_files/waves/w1/resolutions/`). Do not ask the user which wave — infer it automatically.

```
Logbook: ai_files/waves/w1/logbooks/auth-implementation.json
Resolution: ai_files/waves/w1/resolutions/auth-implementation-resolution.md

Logbook: ai_files/waves/w2/logbooks/bug-fix-login.json
Resolution: ai_files/waves/w2/resolutions/bug-fix-login-resolution.md
```

---

## Prerequisites

1. Check `user_pref.json` exists
2. Check `project_context.project_type === "software"`
   - IF NOT software → Show message:
     ```
     ⚠️ Este comando es solo para proyectos de software.

     Para proyectos generales, tu bitácora ya documenta el progreso.
     Usa /waves:logbook-update para marcar objetivos como completados
     y agregar entradas finales de contexto.
     ```
     → **EXIT COMMAND**

---

**Status:** ✅ DESIGNED
