---
name: reversa-to-do
description: Decomposes the roadmap into atomic actions with sequential IDs, dependencies, and parallelism markers. Use when the user types "/reversa-to-do", "reversa-to-do", "decompose into tasks" or asks to turn the roadmap into an executable list. Fourth skill of the forward cycle, after `/reversa-plan`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: to-do
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the decomposer. Your mission is to transform `roadmap.md` into an executable `actions.md`, with atomic tasks, stable IDs, and clear marking of what can run in parallel.


## Autopilot awareness

This skill MAY emit `Type CONTINUE` style prompts between artifacts. Before doing so, read the `autopilot` field from `.reversa/state.json` (`off` / `unit` / `full`, default `off`) and follow the matrix in `agents/reversa/references/autopilot-mode.md`:

- `off`  → pause as usual between every file and every agent handoff.
- `unit` → auto-continue between files inside one unit; still pause between units / agents.
- `full` → auto-continue everywhere; replace `Type CONTINUE` with a one-line `✅ done → next ...` progress note. Do NOT prompt for confirmation.

Hard pauses (clarifying questions, about to overwrite a user file, context budget low, user typed STOP / 停止 / PARAR) MUST always be honored, regardless of `autopilot` value.

The user can switch mode mid-run by editing `.reversa/state.json` or by saying `switch to full autopilot` / 「全自动」 / `slow down` / 「慢点」 — persist the change immediately and confirm in one line.

## Before you begin

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial Checks

1. Read `.reversa/active-requirements.json`
   1.1. If absent, abort pointing to `/reversa-requirements`
2. Verify the existence of `feature-dir/roadmap.md`
   2.1. If absent, abort with a clear message pointing to `/reversa-plan`. Do not attempt to fill in the roadmap here
3. Also load `feature-dir/data-delta.md` and `feature-dir/interfaces/*` if they exist
4. Apply `before-to-do` in the standard way

## Decomposition Strategy

1. Use the five standard phases in order:
   1.1. Preparation (setup, scaffolding, initial migrations, configuration)
   1.2. Tests (tests that need to exist before or right after the core, if the team practices TDD)
   1.3. Core (central logic of the feature)
   1.4. Integration (glue with other parts of the system, external contracts, hooks)
   1.5. Polish (logs, telemetry, messages, short documentation)
2. For each item in `roadmap.md`, derive one or more actions
3. Break each action down to the point where it can be executed in a single coherent block, without needing to switch topics
4. Assign IDs `T001`, `T002`, ..., zero-padded with three digits
5. Mark with `[//]` at the beginning of the line tasks that touch different files AND do not depend on each other
6. In an explicit column, record dependencies by ID (e.g., `T005 depends on T001, T003`)
7. In an explicit column, record the main target file (e.g., `src/payments/pdf.js`)
8. In the `confidence` column, inherit the corresponding decision from the roadmap

## "Atomic" Criteria

- An action is atomic when it can be completed by an agent in a single turn, without needing human feedback in the middle
- If an action has more than five logical sub-points, break it
- If an action touches more than three unrelated files, break it
- If an action includes "and also", "then", "after that", break it

## Building actions.md

1. Load the template `.reversa/templates/actions-template.md`
2. For each phase, create a table with columns `ID | Description | Dependencies | Parallelism | Target file | Confidence | Status`
3. Status always starts as `[ ]`
4. Before the first table, include a summary:
   4.1. Total number of actions
   4.2. Total number of parallelizable actions
   4.3. Longest dependency chain

## Maintenance Rules

- IDs are never recycled, even if an action is removed in a later review
- Renumbering only happens when the document is generated for the first time
- Never insert actions like "configure IDE", "run lint", "open PR", that is not Reversa's responsibility

## Persistence

- Write `feature-dir/actions.md` with atomic write

## Post-execution Hooks

Apply `after-to-do` in the standard way.

## Final Report

1. Absolute path of `actions.md`
2. Total actions per phase
3. Total marked as `[//]`
4. Suggested next step, in order:
   4.1. `/reversa-audit` if you noticed inconsistency while decomposing
   4.2. `/reversa-coding` otherwise

End with:

> Type **CONTINUE** (or **继续**) to proceed according to the suggestion above.
