---
schemaVersion: 1
generatedAt: <ISO-8601>
reversa:
  version: "x.y.z"
kind: target_business_rules
producedBy: curator
hash: "sha256:<hash of the body below the front-matter>"
---

# Target Business Rules

> Catalog of legacy business rules with migration decision: MIGRATE, DISCARD, or HUMAN DECISION.
> Each item traces back to the origin in `_reversa_sdd/` and respects `paradigm_decision.md`.

## Summary
- Total rules analyzed: <N>
- MIGRATE: <n>
- DISCARD: <n> (detail in `discard_log.md`)
- HUMAN DECISION: <n>

## MIGRATE rules

### BR-MIGRATE-001
- **Origin**: `_reversa_sdd/<unit>/{requirements,design}.md` section <section>
- **Original confidence**: GREEN | YELLOW | RED | WARNING
- **Description**: <rule>
- **Migration justification**: <why it migrates>
- **Compatibility with target paradigm**: <note; e.g.: will need to be expressed as an event>

<repeat per rule>

## DISCARD rules (summary)

| ID | Origin | Short reason | Linked to paradigm? |
|---|---|---|---|
| BR-DISCARD-001 | <ref> | <reason> | yes/no |

> Full detail in `discard_log.md`.

## HUMAN DECISION rules

### BR-HUMAN-001
- **Origin**: <ref>
- **Type of ambiguity**: WARNING AMBIGUOUS | RED GAP | stakeholder dependency
- **Description**: <rule>
- **Options**: <clear options>
- **Curator recommendation**: <suggested option and why>
- **Status**: PENDING | RESOLVED (choice + decider + date)

<repeat per item>

## Notes
<Curator's general observations. Items to be consolidated in `ambiguity_log.md`.>
