---
name: reversa-clarify
description: Generates up to five targeted questions to resolve ambiguous points in the requirements and integrates the answers into the document. Use when the user types "/reversa-clarify", "reversa-clarify", "clarify doubts" or asks to resolve open points in the requirements before planning. Optional step in the forward cycle, between `/reversa-requirements` and `/reversa-plan`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: clarify
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the clarifier. Your mission is to discover what needs to be known before the plan and return the answers to the active feature's `requirements.md`.

## Before you begin

1. Read `.reversa/state.json` to resolve `output_folder` (reverse extraction) and `forward_folder` (forward features)
2. When this skill's text mentions `_reversa_sdd/` or `_reversa_forward/`, use the actual values from state.json

## Initial checks

1. Read `.reversa/active-requirements.json`
   1.1. If the file does not exist, abort with a clear message pointing the user to `/reversa-requirements`
2. Load the `requirements.md` from the indicated `feature-dir`
3. Apply the default `before-clarify` hooks rule read from `.reversa/hooks.yml` (same logic as the `reversa-requirements` skill)

## Question generation

1. Examine `requirements.md` looking for:
   1.1. Explicit `[DOUBT]` markers
   1.2. Vague phrases ("probably", "maybe", "if possible", "some")
   1.3. Open terms without definition (numeric limits, user profiles, expected formats)
   1.4. Obvious coverage gaps (missing negative scenario, implicit edge case)
2. Cross-reference with the internal taxonomy below to choose candidates
3. Select at most five questions, ranked by impact on the plan
4. Each question must be either multiple choice or short answer, never open-ended without options

### Taxonomy for prioritization

1. Functional scope and behavior
2. Domain model and data
3. Interaction flow and experience
4. Non-functional attributes (performance, security, observability)
5. Integrations and external dependencies
6. Permissions and authentication
7. Persistence and data migration
8. Audit, logging and telemetry
9. Internationalization and localization
10. Failures and recovery
11. Compatibility with the legacy mapped in `_reversa_sdd/`

## Presentation to the user

Present the questions in the format:

```
1. <question>
   a) <option>
   b) <option>
   c) <option>
   d) <option>
   e) Free response

2. ...
```

If a question is short answer, omit the options block and use format `Expected answer: <value type hint>`.

Wait for the user to respond. If they only answer some, proceed only with the answered ones.

## Integration into requirements.md

1. Locate or create the `## Clarifications` section
2. Within it, create or update `### Session YYYY-MM-DD`
3. For each answered question:
   3.1. Add an item in format `- **Q:** <question>` plus `**A:** <answer>`
   3.2. Locate the section of the requirements where the doubt lived
   3.3. Rewrite the section in-place, removing the corresponding `[DOUBT]`
4. Update the `## Gaps` section removing resolved entries and keeping unresolved ones

## Persistence

- Write the modified `requirements.md` atomically
- The `## Clarifications` section should be right before `## Gaps`

## Post-execution hooks

Apply the default rule for `after-clarify` (same logic as the `reversa-requirements` skill).

## Final report

1. Absolute path of `requirements.md`
2. Number of doubts resolved in this session
3. Number of remaining `[DOUBT]` markers
4. Suggested next step:
   4.1. If there are still `[DOUBT]` markers, suggest running `/reversa-clarify` again
   4.2. If zeroed, suggest `/reversa-plan`

End with:

> Type **CONTINUE** (or **继续**) to proceed according to the suggestion above.
