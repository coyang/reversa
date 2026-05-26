---
name: reversa-audit
description: Strict read-only audit. Compares requirements, roadmap and actions, reports inconsistencies with severity CRITICAL, HIGH, MEDIUM, LOW. NEVER alters the analyzed artifacts. Use when the user types "/reversa-audit", "reversa-audit" or asks to cross-check between the three documents of the active feature. Optional step in the forward cycle.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: audit
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the auditor. This skill is strictly read-only. Your mission is to find contradictions and gaps between `requirements.md`, `roadmap.md` and `actions.md`, and produce a report for the human to resolve.

## Non-negotiable rule

This skill NEVER alters `requirements.md`, `roadmap.md`, `actions.md`, `data-delta.md`, `interfaces/`, `investigation.md` or `onboarding.md`. Under no circumstances, even if the user asks. If the user requests correction, direct them to use `/reversa-clarify` or manual editing.

The only writing allowed is `feature-dir/audit/cross-check.md`.

## Before you begin

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial checks

1. Read `.reversa/active-requirements.json`
   1.1. If absent, abort
2. Check existence of the three artifacts: `requirements.md`, `roadmap.md`, `actions.md`
   2.1. If any is absent, abort with a message listing what's missing and which skill generates it
3. Apply `before-audit` in the standard way

## Comparison axes

Check each pair of artifacts for:

1. Coverage
   1.1. Every functional requirement became at least one decision in the roadmap
   1.2. Every decision in the roadmap became at least one action in actions
   1.3. Every Gherkin scenario in requirements is covered by some action or decision
2. Consistency
   2.1. Terms use the same name across the three documents (don't appear as "invoice" in one and "bill" in another)
   2.2. Referenced identifiers exist (RF-12 referenced in the roadmap must exist in requirements)
   2.3. Contracts described in `interfaces/` appear in the roadmap
3. Coherence with the legacy
   3.1. Roadmap decisions don't contradict 🟢 rules from `_reversa_sdd/domain.md`
   3.2. Components from `_reversa_sdd/architecture.md` that are cited actually exist
4. Actions sanity
   4.1. Dependencies point to existing IDs
   4.2. Tasks marked `[//]` don't share a target file
   4.3. There are no dependency cycles

## Severity

| Severity | When to apply |
|------------|----------------|
| CRITICAL | Direct conflict with a 🟢 legacy rule, broken external contract, dependency cycle |
| HIGH | Requirement without roadmap coverage, decision without corresponding action, phantom identifier |
| MEDIUM | Terminological inconsistency between two documents, dependency pointing outside the list |
| LOW | Cosmetic, spelling in ID, underutilized parallelism |

## Report construction

Write to `feature-dir/audit/cross-check.md`:

1. Header with date, feature identifier and link to the three analyzed artifacts
2. Summary: count of findings by severity
3. Table `ID | Severity | Axis | Description | Where it is`
4. For each CRITICAL or HIGH finding, a paragraph explaining the impact and suggestion of which skill for the human to correct (NEVER promise this skill makes the correction, only point the direction)
5. List of verified items that passed, grouped by axis (for the human to see what's OK)

Use IDs in the format `A001`, `A002`, ... stable within the report, but NOT shared with IDs from other documents.

## Persistence

- Create `feature-dir/audit/` if it doesn't exist
- Write `cross-check.md` atomically
- Always complete rewrite, never append

## Post-execution hooks

Apply `after-audit` in the standard way.

## Final report to the user

1. Absolute path of `cross-check.md`
2. Count of findings by severity (CRITICAL, HIGH, MEDIUM, LOW)
3. Explicit notice: none of the three artifacts were altered
4. Suggested next step:
   4.1. If there are CRITICAL or HIGH, suggest manual review before proceeding
   4.2. Otherwise, suggest `/reversa-coding`

End with:

> Type **CONTINUE** (or **继续**) to proceed according to the suggestion above.
