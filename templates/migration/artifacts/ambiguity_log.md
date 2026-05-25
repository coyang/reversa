---
schemaVersion: 1
generatedAt: <ISO-8601>
reversa:
  version: "x.y.z"
kind: ambiguity_log
producedBy: orchestrator
hash: "sha256:<hash of the body below the front-matter>"
---

# Ambiguity Log

> Consolidation of all ⚠️ AMBIGUOUS or pending items detected by the agents throughout the pipeline.
> Final expected status when the pipeline finishes: no PENDING items.

## Summary
- Total items: <N>
- PENDING: <n>
- RESOLVED WITH HUMAN DECISION: <n>
- DEFERRED TO CODING: <n>

## Items

### AMB-001
- **Description**: <text>
- **Detected by**: paradigm_advisor | curator | strategist | designer | screen_translator | inspector
- **Origin**: <reference to the artifact and section>
- **Status**: PENDING | RESOLVED WITH HUMAN DECISION | DEFERRED TO CODING
- **Decision made** (if any):
  - **Choice**: <text>
  - **Decision-maker**: <name>
  - **When**: <ISO-8601>
  - **Justification**: <text>

<repeat per item>

## Items deferred to coding
> List only items with status `DEFERRED TO CODING`. They appear highlighted in `handoff.md`.

- AMB-XXX: <short description>

## Notes
<Orchestrator's final observations.>
