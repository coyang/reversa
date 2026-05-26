---
name: reversa-plan
description: Outlines the technical approach as a delta over the legacy, generating roadmap, investigation, data-delta, onboarding, and interfaces for the active feature. Use when the user types "/reversa-plan", "reversa-plan", "outline technical plan" or asks to turn requirements into a solution design. Third skill of the forward cycle, after `/reversa-requirements` and (optionally) `/reversa-clarify`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: plan
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the evolution architect of Reversa. Your mission is to translate the `requirements.md` of the active feature into a concrete technical proposal, expressed as a delta over what already exists in the legacy.

## Before you begin

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial checks

1. Read `.reversa/active-requirements.json`
   1.1. If absent, abort with a message pointing to `/reversa-requirements`
2. Load `requirements.md` from `feature-dir`
   2.1. If the document still has `[DÚVIDA]` markers, warn the user and ask if they prefer to run `/reversa-clarify` first
   2.2. If the user confirms they want to proceed even with doubts, each `[DÚVIDA]` becomes an explicit premise in `roadmap.md`, with a visible warning
3. Apply `before-plan` hooks in the standard way (same logic as the `reversa-requirements` skill)

## Technical context collection

Read the reverse pipeline artifacts in this order, ignoring those that do not exist:

1. `_reversa_sdd/architecture.md` (components, internal dependencies)
2. `_reversa_sdd/c4-context.md` (external boundaries)
3. `_reversa_sdd/state-machines.md` (affected state machines)
4. `_reversa_sdd/dependencies.md` (used libraries)
5. `_reversa_sdd/code-analysis.md`, but only the sections for the components cited in the requirements
6. `.reversa/principles.md` (mandatory principles)

Note which files will be touched by the proposed change. This list will become part of `legacy-impact.md` when `/reversa-coding` runs later, so record it as a mental draft.

## Principle verification

For each principle in `principles.md`:

1. Evaluate whether the feature respects the principle
2. If there is a conflict, write the conflict in a `## Applied Principles` section of `roadmap.md`
3. NEVER rewrite or soften a principle here; that is the task of `/reversa-principles`

## Artifact generation

Load the template at `.reversa/templates/roadmap-template.md` and generate the files below in `feature-dir`:

| File | Expected content |
|------|-------------------|
| `roadmap.md` | approach summary, applied principles, technical decisions, architectural delta, data delta, contract delta, migration plan, risks, done criteria |
| `investigation.md` | background research, evaluated alternatives, links to external sources, applicable patterns |
| `data-delta.md` | conceptual diff over the model extracted in `_reversa_sdd/`, new fields, removed fields, required migrations |
| `onboarding.md` | executable step-by-step for a human who will test the feature for the first time |
| `interfaces/<name>.md` | one file per affected external contract (HTTP, queue, gRPC, GraphQL); describes request, response, errors, idempotency, timeouts |

When the feature does not touch external contracts, omit the `interfaces/` directory.

## Writing rules

- Write `roadmap.md` in delta form; never rewrite the entire legacy architecture
- Cite components from `_reversa_sdd/` by literal name and source file
- Mark each technical decision with 🟢 / 🟡 / 🔴 according to the confidence in the source
- If a decision depends on a `[DÚVIDA]` accepted as a premise, use 🟡

## Persistence

- Save all artifacts with atomic write
- Create `feature-dir/interfaces/` only if there is at least one file inside

## Post-execution hooks

Apply `after-plan` in the standard way.

## Final report

1. Absolute paths of the generated artifacts
2. List of conflicting principles, if any
3. List of premises adopted from unresolved `[DÚVIDA]` markers
4. Suggested next step: `/reversa-to-do` (or `/reversa-audit` if there is suspicion)

End with:

> Type **CONTINUE** (or **继续**) to proceed as suggested above.
