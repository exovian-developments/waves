---
description: Initialize waves preferences and project context
allowed-tools: Read, Write, Edit
---

# Plugin Command: project-init

You are executing the waves plugin project initialization command. This is an interactive setup command — do NOT use the Task tool. Conduct this directly in the main thread.

## Your Role

You are the main orchestrator for project initialization. Conduct an interactive setup to create user preferences and project context.

## Step 0: Language Selection

Display this welcome banner exactly:

```
▄▀█ █   █▄▄ █▀▀ █ █ ▄▀█ █ █ █ █▀█ █▀█
█▀█ █   █▄█ ██▄ █▀█ █▀█ ▀▄▀ █ █▄█ █▀▄

« structured context for AI agents »
  Claude · Codex · Gemini CLI

🌍 What language do you prefer for our conversations?

Examples: English, Español, Português, Français, Deutsch, 日本語

Type your preferred language:
```

Wait for user response. Store as `preferred_language`. Normalize to ISO code if possible (es, en, pt, etc.).

Confirm: "✓ Language set to: [language]"

**From this point, conduct ALL interactions in the user's chosen language.**

## Step 1: Check Existing Configuration

Check if `ai_files/user_pref.json` exists.

IF EXISTS, ask in user's language:
```
⚠️ A configuration already exists in this project!

Options:
1. Stop (keep existing)
2. Continue (overwrite)

Choose 1 or 2:
```

IF user chooses 1 → Exit with message about using `project-init` update command instead.
IF user chooses 2 → Continue.

## Step 2: Command Explanation

Display in user's language:
```
📘 Command: project-init

This command configures your essential preferences for working with waves.
I'll ask you 5 questions to set up how I interact with you and understand your project.

Continue? (Yes/No)
```

IF No → Exit.

## Step 3: Question 1 — Name + Role

Ask in user's language:
```
👤 What is your name and role in this project?

Example: 'Alex - Senior Frontend Developer'
         'María - Lead Researcher'
         'João - Product Manager'
```

Parse response:
- Try to split by "-", ":", or similar
- Extract `name` and `technical_background`
- If role not detected, ask follow-up: "What is your role or specialty?"

## Step 4: Question 2 — Project Type

Ask in user's language:
```
🎯 What type of project is this?

1. Software project - Application, API, system, code
2. General project - Research, business, creative, academic, other

Choose 1 or 2:
```

Store: `project_type = "software"` (if 1) or `"general"` (if 2)

## Step 5: Question 3 — Project Familiarity

Ask in user's language:
```
📚 How familiar are you with this project?

1. I know it well - I understand its structure and technologies
2. It's new to me - I need to explore it, understand it, or I'm creating it from scratch

Choose 1 or 2:
```

Store: `is_project_known_by_user = true` (if 1) or `false` (if 2)

## Step 6: Question 4 — Communication Tone

Ask in user's language:
```
💬 How do you prefer I communicate with you?

Examples:
• 'Professional' - Respectful and focused
• 'Friendly with humor' - Casual with touches of sarcasm
• 'Direct' - No fluff, straight to the point
• Or describe your preference in your own words

Type your preference:
```

Map to enum: `formal`, `neutral`, `friendly`, `friendly_with_sarcasm`, `funny`, `strict`
Use closest match or store as custom.

## Step 7: Question 5 — Explanation Style

Ask in user's language:
```
📚 What level of detail do you prefer in explanations?

Examples:
• 'Direct' - Short answers without extra explanations
• 'Balanced' - Explanation with relevant technical context
• 'Teaching mode' - Explain every step in depth
• Or describe your preference

Type your preference:
```

Map to enum values from schema.

## Step 8: Generate Configuration

Display in user's language:
```
⚙️ Generating your configuration...

The following preferences are set with default values.
You can adjust them later with: project-init (update variant)

📋 Default values applied:

LLM Behavior:
  • explain_before_answering: true
  • ask_before_assuming: true
  • suggest_multiple_options: true
  • allow_self_correction: true
  • persistent_personality: true
  • feedback_loop_enabled: true

User Profile:
  • emoji_usage: true
  • learning_style: explicative

Output Preferences:
  • format_code_with_comments: true
  • highlight_gotchas: true
```

## Step 9: Create user_pref.json

Read the schema from `${CLAUDE_PLUGIN_ROOT}/skills/waves-protocol/references/user_pref_schema.json` to understand the structure.

Create `ai_files/user_pref.json` with:
- User's answers from questions 1-5
- Default values for all other fields
- Proper JSON structure matching the schema

## Step 10: Update or Create CLAUDE.md

Check if `CLAUDE.md` exists in project root.

IF EXISTS:
- Read current contents
- Prepend the following Waves framework training block at the top (before existing content):

```markdown
# Waves Framework — Agent Operating Protocol

This project uses the **Waves** product development framework. As an AI agent, you MUST follow these guidelines:

## User Preferences

Read and follow user preferences from: ai_files/user_pref.json

## Directory Structure

All Waves artifacts live in `ai_files/`:

ai_files/
├── user_pref.json              ← User preferences (language, style)
├── project_manifest.json       ← Technical project analysis
├── project_rules.json          ← Coding rules and standards
├── schemas/                    ← JSON schemas for validation
│
├── feasibility.json            ← Market/technical feasibility (Sub-Zero)
├── foundation.json             ← Validated facts from feasibility (Sub-Zero)
├── blueprint.json              ← Product definition: WHAT and WHY (W0)
│
└── waves/                      ← Delivery cycles
    ├── sub-zero/               ← Validation / Knowledge acquisition
    │   ├── roadmap.json
    │   └── logbooks/
    ├── w0/                     ← Product definition
    │   ├── roadmap.json
    │   └── logbooks/
    ├── w1/                     ← Business wave 1
    │   ├── roadmap.json        ← WHEN and ORDER for this wave
    │   ├── logbooks/           ← HOW and DETAIL (per ticket)
    │   └── resolutions/        ← Completed logbook summaries
    └── wN/                     ← Subsequent business waves
        ├── roadmap.json
        ├── logbooks/
        └── resolutions/

## Artifact Hierarchy (Golden Rule)

blueprint.json              ← WHAT / WHY (source of truth)
  └── waves/wN/roadmap.json ← WHEN / ORDER (wave plan)
       └── logbooks/*.json  ← HOW / DETAIL (ticket execution)

**Nothing exists in the project that is not supported in the blueprint.** Every roadmap references the blueprint. Every logbook belongs to a roadmap.

## Required Agent Behaviors

1. **Before starting any task**, read `ai_files/blueprint.json` to understand the product context. If no blueprint exists, ALERT the user: "No product blueprint found. Consider running /waves:blueprint-create to define the product before implementation."

2. **Before implementing code**, check for an active roadmap in `ai_files/waves/`. If no roadmap exists, ALERT the user: "No active roadmap found. Consider running /waves:roadmap-create to plan the wave."

3. **When given a task**, check if a logbook exists for it in the active wave's `logbooks/` directory. If not, RECOMMEND: "No logbook found for this task. Consider running /waves:logbook-create to track objectives and context."

4. **Reference artifacts in responses**. When discussing features, mention which capability from the blueprint they support. When reporting progress, reference the roadmap milestone.

5. **Follow the Waves order**:
   - Sub-Zero: feasibility → foundation (validate the idea)
   - W0: blueprint → roadmap → project setup (define the product)
   - W1+: logbook → implement → update logbook → resolution (deliver value)

6. **Alert on missing artifacts**:
   - No blueprint → "The product is not defined yet"
   - No roadmap → "There's no plan for the current wave"
   - No logbook for current task → "This task isn't being tracked"
   - Logbook can't trace to blueprint → "This work may not be aligned with the product"

7. **When artifacts exist, USE them**:
   - Read `project_rules.json` before writing code
   - Read the active roadmap to understand priorities
   - Read relevant logbooks for implementation context
   - Read `project_manifest.json` for architecture context

## Wave Lifecycle

Waves are organic delivery cycles (not fixed sprints). A wave lasts as long as needed.

| Wave | Purpose | Key artifacts |
|------|---------|---------------|
| Sub-Zero | Validate the idea | feasibility.json, foundation.json |
| W0 | Define the product | blueprint.json, roadmap for W1 |
| W1+ | Deliver to production | roadmaps, logbooks, resolutions |

## Waves Commands Available

- `/waves:feasibility-analyze` — Market/technical feasibility analysis
- `/waves:foundation-create` — Compact feasibility into validated facts
- `/waves:blueprint-create` — Define the product (WHAT and WHY)
- `/waves:roadmap-create` — Plan a wave (WHEN and ORDER)
- `/waves:logbook-create` — Create implementation logbook (HOW)
- `/waves:logbook-update` — Update logbook with progress
- `/waves:objectives-implement` — Execute logbook objectives
- `/waves:roadmap-update` — Update roadmap with progress/decisions
- `/waves:resolution-create` — Generate completion summary
- `/waves:manifest-create` — Analyze project technically
- `/waves:rules-create` — Extract coding standards

---

```

Then append the original CLAUDE.md content below the `---`.

IF NOT EXISTS:
- Create `CLAUDE.md` with the same Waves framework training block above (without the trailing `---`).

## Step 11: Success Message

Display in user's language:
```
✅ Configuration complete!

📁 Files updated:
  • ai_files/user_pref.json (created)
  • CLAUDE.md (updated with preferences reference)

Your configuration:
  • Name: [name]
  • Role: [role]
  • Language: [language]
  • Project type: [type]
  • Familiarity: [known/new to you]
  • Tone: [tone]
  • Explanations: [style]

📋 Default preferences applied (see above)

💡 Tip: Adjust advanced preferences with user-pref-create command

⚠️ IMPORTANT: Restart your Claude Code session to load the new preferences.
```

## Step 12: Next Steps

Display in user's language:
```
✅ Result: User preferences configured and ready to use.

📁 Generated files:
  • ai_files/user_pref.json
  • CLAUDE.md (updated)

🎯 Next step:

  After restarting Claude Code, run:
  manifest-create

  This command will analyze your project and create a complete manifest
  with its structure, technologies, and architecture.
```

END OF COMMAND
