---
name: reversa-principles
description: Creates or updates the enduring principles of the project and propagates adjustment suggestions in dependent templates. Principles are rare, change infrequently, and influence all artifacts. Use when the user types "/reversa-principles", "reversa-principles", "define principles" or asks to create/change/retire a project principle. Can run even before the first feature.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: principles
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the guardian of principles. This skill handles enduring rules of the project, separate from the specific requirements of each feature. Principles change infrequently and influence all other artifacts.

This skill is rare, typically used less than once a month. It is NOT part of the `requirements`, `plan`, `to-do`, `coding` pipeline. It can run on its own, even before the first feature.

## Before you start

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial Checks

1. Try to read `.reversa/principles.md`
   1.1. If absent, mode is `create`
   1.2. If present, mode is `update`
2. Apply `before-principles` in the standard way

## Create mode

1. Load `.reversa/templates/principles-template.md`
2. Ask the user for candidate principles, in batch or one at a time
3. For each principle:
   3.1. Assign sequential Roman numeral numbering (I, II, III, ...)
   3.2. Ask for a short title, description, and a concrete application example
   3.3. Record the creation date
4. List, in the "Impact" section, which templates will be affected when the principle changes (always `requirements-template.md`, `roadmap-template.md`, and potentially `actions-template.md`)
5. Start the "Change History" section with the initial entry

## Update mode

1. Present the user with the current list of numbered principles
2. Ask which operation they want:
   2.1. Add new (continues with the next Roman numeral, never recycles)
   2.2. Change the text of an existing one (keeps numbering, records the change in history)
   2.3. Retire one (does NOT delete, marks as `retired on YYYY-MM-DD` and moves to the end of the document)
3. After the operation:
   3.1. Update the "Impact" section if necessary
   3.2. Add an entry to "Change History"

## Impact propagation

1. For each template listed in the "Impact" section:
   1.1. Read the template in `.reversa/templates/<name>`
   1.2. Check if the template needs a new placeholder or section to reflect the principle
   1.3. NEVER rewrite the entire template automatically, only generate an impact report in `.reversa/principles-impact-YYYYMMDD.md`
2. The report lists, per template, textual adjustment suggestions
3. Applying these suggestions is a human decision; this skill only suggests

## Persistence

- Write `.reversa/principles.md` with atomic write
- Write the impact report to `.reversa/principles-impact-YYYYMMDD.md`
- Never overwrite old impact reports; each execution creates a dated file

## Post-execution Hooks

Apply `after-principles` in the standard way.

## Final report to the user

1. Absolute path of `principles.md`
2. List of active principles, with numbering and short title
3. List of retired principles, if any
4. Path of the generated impact report
5. Notice: new or changed principles only take effect for features started after this date

End with:

> Type **CONTINUE** (or **继续**) to proceed with the next action you wish.

## Autopilot awareness

This skill MAY emit `Type CONTINUE` style prompts between artifacts. Before doing so, read the `autopilot` field from `.reversa/state.json` (`off` / `unit` / `full`, default `full`) and follow the matrix in `agents/reversa/references/autopilot-mode.md`:

- `off`  → pause as usual between every file and every agent handoff.
- `unit` → auto-continue between files inside one unit; still pause between units / agents.
- `full` → auto-continue everywhere; replace `Type CONTINUE` with a one-line `✅ done → next ...` progress note. Do NOT prompt for confirmation.

Hard pauses (clarifying questions, about to overwrite a user file, context budget low, user typed STOP / 停止 / PARAR) MUST always be honored, regardless of `autopilot` value.

The user can switch mode mid-run by editing `.reversa/state.json` or by saying `switch to full autopilot` / 「全自动」 / `slow down` / 「慢点」 — persist the change immediately and confirm in one line.

