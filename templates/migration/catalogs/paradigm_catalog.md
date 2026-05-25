---
schemaVersion: 1
kind: paradigm_catalog
description: Advisory catalog of programming paradigms, mapping of stacks to their natural paradigm, and typical gaps per pair (source → target). Used by the Paradigm Advisor.
---

# Paradigm Catalog

> Structured knowledge about paradigms and how they relate to common stacks.
> Updating this catalog is a maintenance task independent of the Paradigm Advisor agent.

## Paradigm catalog

### Procedural
- **Characteristics**: top-level functions, linear flow in controllers, no classes or ornamental use, data as dicts/structs, open side effects.
- **Examples in the legacy**: classic PHP scripts, COBOL batch, pre-OO Perl systems, shell scripts.
- **Signals in `_reversa_sdd/`**: domain described as "functions", linear flows in `process_flows`, absence of explicit aggregates.

### Classical OO
- **Characteristics**: class hierarchy, strong inheritance, Active Record pattern, logic coupled to models, framework dictates structure.
- **Examples in the legacy**: monolithic Rails, traditional Django, pre-DI Java EE, .NET WebForms / classic.
- **Signals in `_reversa_sdd/`**: classes with broad responsibilities, inheritance in the domain model, anemic controllers calling model methods.

### OO with DI
- **Characteristics**: injection containers, explicit interfaces, Repository / Service pattern, clear separation between layers.
- **Examples in the legacy**: modern Spring, .NET 6+, NestJS, modern Symfony.
- **Signals in `_reversa_sdd/`**: explicit aggregates, repository interfaces, absence of Active Record.

### Functional
- **Characteristics**: dominant immutability, pure functions, composition, no implicit side effects, rich typing.
- **Examples in the legacy**: Haskell, Elm, F#, functional Scala, Clojure.
- **Signals in `_reversa_sdd/`**: algebraic types, no classes, flow expressed as composition.

### Event-driven (asynchronous)
- **Characteristics**: queues / topics, decoupled handlers, no linear flow, eventual consistency, explicit idempotency.
- **Examples in the legacy**: modern queue-oriented Node backends, SQS / Kafka heavy systems, asynchronous microservices.
- **Signals in `_reversa_sdd/`**: events in the domain model, integrations via queue, long-running processes with retry.

### Actor model
- **Characteristics**: isolated actors with a mailbox, supervision, state isolation.
- **Examples in the legacy**: Erlang / Elixir / OTP, Akka.
- **Signals in `_reversa_sdd/`**: supervised processes, messages between actors.

### Dataflow
- **Characteristics**: declarative pipelines, streamed transformations, no imperative loops in the domain.
- **Examples in the legacy**: classic ETLs, Spark, Flink.
- **Signals in `_reversa_sdd/`**: DAG description, transformations in stages.

## Mapping stack → natural paradigm

| Target stack | Natural paradigm | Viable alternatives | Notes |
|---|---|---|---|
| Node.js 20 (Fastify, Express, NestJS) | asynchronous event-driven | OO with DI (NestJS), light functional | async-first runtime; heavy CPU blocking goes to worker threads |
| Go (net/http, Echo, Fiber) | CSP / goroutines (light event-driven) | structured procedural | concurrency via channels; OO simulated via interfaces |
| Rust (axum, Actix, tokio) | ownership / async functional | event-driven | immutability by default, type-driven safety |
| Elixir / Phoenix | actor model (BEAM) | functional | supervision via OTP |
| Modern Python (FastAPI, Django 5) | OO with DI or rich procedural | event-driven (Celery, asyncio) | choice depends on the framework |
| Kotlin (Spring Boot, Ktor) | OO with DI | event-driven (Reactor) | coroutines enable ergonomic async |
| .NET 8 (ASP.NET Core, Minimal API) | OO with DI | event-driven (Channels, MediatR) | OO tradition + first-class async |
| Modern Java (Spring Boot 3, Quarkus) | OO with DI | event-driven (Project Reactor) | functional libraries possible but not dominant |
| Modern Ruby (Rails 7, Hanami) | classical OO (Rails) or OO with DI (Hanami) | light functional (dry-rb) | Rails dictates Active Record; Hanami is DI-heavy |
| Serverless TypeScript (AWS Lambda, Cloudflare Workers) | event-driven | functional | event-driven invocation; cold start influences design |

## Table of typical gaps per pair

| From → To | Main gap | Concrete implications |
|---|---|---|
| procedural → event-driven | sync → async | response stops being immediate; error handling becomes retry/DLQ; idempotency is mandatory; event order starts to matter |
| procedural → OO with DI | data as dict → aggregates | invariants stay inside aggregates; logic stops living in controllers; dependencies via interfaces |
| procedural → functional | open side effects → pure + isolated | mutability becomes the exception; composition replaces sequence; algebraic types for states |
| classical OO → event-driven | sync flow → choreography | actions stop being atomic; distributed transactions become sagas; strong consistency → eventual |
| classical OO → OO with DI | inheritance → composition via interfaces | Active Record disappears; persistence becomes a repository; tests get natural mocks |
| classical OO → functional | mutable encapsulation → immutability | side-effecting methods become pure functions + explicit update; state expressed as a sequence of transformations |
| OO with DI → event-driven | synchronous command → event | return stops being immediate; orchestration becomes choreography; order by key |
| OO with DI → functional | mocks → testable composition | DI stops being via interface, becomes via function argument |
| functional → event-driven | sync composition → messaging | latency increases; failure becomes a message in DLQ; distributed state |
| event-driven → synchronous procedural | unnatural; only makes sense for small systems | collapse handlers into direct calls; loss of decoupling; strong consistency returns |
| dataflow → event-driven | declarative DAG → mutable choreography | control becomes less predictable; order needs to be ensured by key |
| actor model → OO with DI | messages between actors → synchronous calls | loss of failure isolation; supervision needs to become try/catch or orchestrated retry |

## Utility function (used by the Paradigm Advisor)

Pseudo-procedure that the agent follows when consulting the catalog:

1. Receive `legacy_paradigm` (detected) and `target_stack` (from the brief).
2. Look at `Mapping stack → natural paradigm`, record `target_paradigm` and `alternatives`.
3. Compare `legacy_paradigm` with `target_paradigm`:
   - If equal: return `gap = none`, `implications = []`.
   - If different: look at `Table of typical gaps per pair` and return `implications`.
4. If hybrid in the legacy: apply step 3 to each component and return the combined list.

## Test scenarios for the catalog (for validation)

1. procedural legacy + Node stack → gap = procedural → event-driven, implications = [sync/async, idempotency, retry/DLQ, order]
2. classical OO legacy + .NET 8 stack → gap = classical OO → OO with DI, implications = [inheritance/composition, repository, mocks]
3. classical OO legacy + Go stack → gap = classical OO → CSP, implications = [idiomatic interfaces, channels for coordination, loss of inheritance]
4. functional legacy + Elixir stack → gap = functional → actor model, implications = [distributed state, supervision, messages]
5. event-driven legacy + Node stack → gap = none
6. COBOL batch legacy + serverless TypeScript stack → extreme gap, multiple implications: batch → event-driven, procedural → rich typing, no long loops → short invocations
7. monolithic Rails legacy + Hanami stack → gap = classical OO (Active Record) → OO with DI, implications = [repository, optional dry-monads]
8. hybrid legacy (Rails + Sidekiq) + Node stack → hybrid decomposed: synchronous Rails part → Node sync; async Sidekiq part → Node modern queue
