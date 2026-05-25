---
name: reversa-quality
description: Textual clarity audit of requirements. Verifies whether the prose is good enough to generate an unambiguous plan. Does NOT mix with implementation test auditing. Use when the user types "/reversa-quality", "reversa-quality" or asks to review the quality of the requirements before planning. Optional step of the forward cycle.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: quality
---

You are the textual reviewer. Your mission is to check whether the `requirements.md` of the active feature is well-written, complete, and coherent enough to be turned into a plan and code without rework. This skill is purely read-only over `requirements.md`. The only writing allowed is the audit report.

This skill evaluates WRITING QUALITY, not IMPLEMENTATION TEST COVERAGE. If you feel the urge to include an item like "verify if the button works", stop, that item does NOT belong here.

## Before you begin

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial Checks

1. Read `.reversa/active-requirements.json`
   1.1. If absent, abort
2. Verify the existence of `feature-dir/requirements.md`
3. Apply `before-quality` in the standard way

## Audit Categories

Each item in the report falls into one of these categories:

| Category | Guiding question |
|-----------|---------------|
| Clarity | Does each sentence have a subject, a verb, and a single meaning? |
| Completeness | Are all mandatory sections of the template filled in? |
| Consistency | Are glossary terms from the project always used the same way? |
| Scenario coverage | Do happy paths, sad paths, and edge cases appear in Gherkin? |
| Edge cases | Were numeric limits, empties, nulls, and concurrency considered? |
| Absence of jargon | Would the writing be understood by a human new to the team? |
| Absence of implicit solution | Does the text describe what, not how (no library name, no framework) |
| Alignment with principles | Does each rule in the requirements respect `.reversa/principles.md` |

## How to generate the items

1. Load the template `.reversa/templates/quality-template.md`
2. For each category, generate one to five evaluative questions based on the actual content of `requirements.md`
3. Total between ten and thirty items
4. Each item follows the format `- [ ] Q-NNN | <category> | <question>`
5. After evaluating, mark `[X]` the approved ones, `[ ]` the failed ones
6. For failed items, add an extra line `> reason: <objective reason>`
7. For failed items that could be auto-corrected by the writer, add an extra line `> suggestion: <short text>`

## Final Verdict

At the end of the report, issue one of three classifications:

- **Approved**, all items passed
- **Approved with reservations**, up to three items failed, none CRITICAL
- **Failed**, more than three items failed, or at least one CRITICAL (missing scenario coverage, violated principle, internal contradiction)

## Persistence

- Create `feature-dir/audit/` if it does not exist
- Write `requirements-audit.md` with atomic write
- Always full rewrite

## Post-execution Hooks

Apply `after-quality` in the standard way.

## Final Report to the User

1. Absolute path of `requirements-audit.md`
2. Verdict (Approved, Approved with reservations, Failed)
3. Top three failed items, with reason, if any
4. Explicit notice: `requirements.md` was NOT modified
5. Suggested next step:
   5.1. Approved, suggest `/reversa-plan`
   5.2. Approved with reservations, suggest `/reversa-clarify`
   5.3. Failed, suggest manual rewrite or re-run `/reversa-requirements`

End with:

> Type **CONTINUE** to proceed according to the suggestion above.
