---
schemaVersion: 1
kind: migration_strategies
description: Advisory catalog of migration strategies with applicability criteria. Used by the Strategist.
---

# Migration Strategies

> Catalog of canonical migration strategies with applicability, cost, risk, time, example, and references.
> Updating this catalog is a maintenance task independent of the Strategist agent.

## Strategies

### Strangler Fig
- **Description**: The new system grows around the legacy, incrementally capturing functionalities until the legacy can be turned off.
- **When it applies**:
  - System in production that cannot stop.
  - Need for incrementality.
  - Possibility of routing between old and new (proxy / API gateway).
- **Cost**: medium.
- **Risk**: low (partial rollback is viable).
- **Time**: long (months to years on large systems).
- **Favored appetite**: conservative, balanced.
- **Example**: an API gateway redirects `/v2/orders/*` endpoints to the new system while `/orders/*` continues on the legacy.
- **References**: Martin Fowler, "StranglerFigApplication"; Sam Newman, "Monolith to Microservices".

### Big Bang
- **Description**: Complete replacement in a single cutover window.
- **When it applies**:
  - Small system.
  - Maintenance window tolerated.
  - High transformational appetite.
  - Low number of live external integrations.
- **Cost**: low (no maintenance of two versions).
- **Risk**: high (full rollback is expensive; failure brings the service down).
- **Time**: short.
- **Favored appetite**: transformational (on small systems).
- **Example**: an internal tool used by 50 people migrated overnight with a documented rollback.
- **References**: described in several migration frameworks; high correlation with historical failures on large systems.

### Parallel Run
- **Description**: Legacy and new run in parallel receiving the same input; output is compared to detect divergences.
- **When it applies**:
  - Critical logic (financial, tax, regulatory).
  - Need for proof of equivalence over a long period.
  - Large paradigm change + transformational appetite (high operational risk).
- **Cost**: high (two stacks operating simultaneously; output comparison).
- **Risk**: medium (risks come from the dual operation, not from the cut).
- **Time**: medium.
- **Favored appetite**: balanced.
- **Example**: tax calculation running on the legacy and on the new for 60 days; cutover only after divergence < 0.01%.
- **References**: Michael Nygard, "Release It!"; common in banking and tax systems.

### Branch by Abstraction
- **Description**: Internal refactoring of the legacy to introduce an abstraction that lets the implementation be swapped underneath, then replaced.
- **When it applies**:
  - Internal migration (language or framework changes, but the domain stays).
  - Conservative appetite.
  - Team already inside the legacy, with deep code knowledge.
- **Cost**: low.
- **Risk**: low.
- **Time**: medium.
- **Favored appetite**: conservative.
- **Example**: extract an `OrderRepository` interface in the legacy, keep the old and new implementations selected via flag, then remove the old.
- **References**: Paul Hammant, "Branch By Abstraction".

## Quick comparison

| Strategy | When it applies | Cost | Risk | Time |
|---|---|---|---|---|
| Strangler Fig | system in production, cannot stop | medium | low | long |
| Big Bang | small system, controlled window, transformational appetite | low | high | short |
| Parallel Run | critical logic (financial / tax) | high | medium | medium |
| Branch by Abstraction | internal refactoring before the migration | low | low | medium |

## Influence of the paradigm on the choice

- **Appetite `conservative`** → favors Branch by Abstraction and Strangler Fig.
- **Appetite `balanced`** → favors Strangler Fig and Parallel Run.
- **Appetite `transformational`** → allows Big Bang on small systems, Strangler Fig with deep boundaries on larger systems.
- **Large paradigm change + transformational appetite** → flag `high operational divergence risk` and recommend Parallel Run for validation.

## Utility function (used by the Strategist)

Pseudo-procedure that the agent follows when consulting the catalog:

1. Receive `migration_brief` (scope, deadline, constraints) + `derived_appetite` + `paradigm gap`.
2. Filter strategies by applicability (drop out those that clearly do not fit).
3. Score each remaining strategy by fit with the appetite and the gap.
4. Select the 2 to 3 best candidates.
5. Mark one as `recommended` with explicit justification.
6. For each remaining strategy, list cons as reasons for non-recommendation.

## Test scenarios for the catalog

1. brief = banking system in production, conservative appetite → recommend Strangler Fig + Branch by Abstraction.
2. brief = internal tool with 50 users, transformational appetite → recommend Big Bang.
3. brief = tax system, balanced appetite, high paradigm change → recommend Parallel Run + Strangler Fig.
4. brief = Rails monolith to Go microservices, transformational appetite, large paradigm change → recommend Strangler Fig with deep boundaries, flag operational risk, suggest Parallel Run for critical domains.
5. brief = .NET WebForms to Blazor, balanced appetite, no large paradigm change → recommend Strangler Fig.
6. brief = legacy system with few integrations, maintenance window tolerated, balanced appetite → recommend Big Bang with a robust rollback plan, alternative Strangler Fig.
