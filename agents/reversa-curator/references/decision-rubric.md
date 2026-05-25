# Curator Decision Rubric

Quick reference table for applying the decision policy.

## Decision table

| Signal observed in the rule | Default decision | Notes |
|---|---|---|
| GREEN CONFIRMED, compatible with target paradigm, no pain point | MIGRATE | no reservations |
| YELLOW INFERRED, compatible with target paradigm | MIGRATE | add note "validate in coding agent" |
| RED GAP | HUMAN DECISION | optional recommendation |
| WARNING AMBIGUOUS | HUMAN DECISION | mandatory listing of interpretations |
| Rule cited as pain point | HUMAN DECISION | default recommendation: replace with X in the new system |
| Rule incompatible with brief (out of scope) | DISCARD | justification: "out of scope as declared in migration_brief.md" |
| Rule incompatible with brief (technical) | DISCARD | justification: "technical constraint from brief prevents" |
| Rule is a mechanism of the legacy paradigm, paradigm changed | DISCARD (linked to paradigm) | indicate replacement in target paradigm |
| Rule is a mechanism of the legacy paradigm, paradigm is the same | MIGRATE | no reservations |

## List of typical paradigm mechanisms (discardable when paradigm changes)

### Procedural -> event-driven
- Pessimistic lock (`SELECT ... FOR UPDATE`)
- Entire ACID transaction around the flow
- Synchronous response to user with inline side effect
- Retry implemented as `for` loop in controller

### Classic OO -> OO with DI
- Active Record mixing persistence and domain
- Inheritance used for behavior reuse (prefer composition)
- Manual singleton (prefer scoped DI)

### Classic OO -> functional
- Mutable encapsulation (prefer immutable types)
- Void methods with side effects (prefer return value + pure function)

### OO with DI -> event-driven
- Synchronous commands with immediate return (prefer event + ack)
- Centralized orchestration (prefer choreography)
- 2PC / distributed transaction (prefer saga)

### Synchronous -> asynchronous in general
- Timeout configured in controller (moves to consumer retry policy)
- Error handling as propagated exception (becomes DLQ)

## What to NEVER discard due to paradigm

- Pure business rules (calculations, conditions, derivations).
- Regulatory rules.
- Domain invariants.
- Rights / permissions.

These rules change **location** in the new paradigm, but they do not disappear.
