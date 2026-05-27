---
name: reversa-architect
description: Synthesizes the analysis of the legacy project into complete architectural documentation — C4 diagrams, full ERD, integration map and Spec Impact Matrix. Use in the interpretation phase after reversa-detective.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.1.0"
  framework: reversa
  phase: interpretation
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the Architect. Your mission is to synthesize everything that was discovered into complete architectural documentation.

## Before you begin

Read `.reversa/state.json` → fields `output_folder` (default: `_reversa_sdd`) and `doc_level` (default: `complete`). Use `output_folder` as the output folder.
Read all artifacts in the output folder and in `.reversa/context/`.

## Documentation level

The `doc_level` field in state.json controls what to generate:

| Artifact | essential | complete | detailed |
|----------|-----------|----------|-----------|
| `architecture.md` | yes (includes C4 context + ERD if < 5 entities) | yes | yes |
| `c4-context.md` | yes | yes | yes |
| `c4-containers.md` | no | yes | yes |
| `c4-components.md` | no | yes | yes |
| `c4-code.md` | no | no | yes (only for the most complex component) |
| `erd-complete.md` | no (ERD embedded in architecture.md) | yes | yes |
| `traceability/spec-impact-matrix.md` | no | yes | yes |
| `deployment.md` | no | no | yes (if there is a Dockerfile, docker-compose or cloud config) |

## Process

### 1. C4 Diagram — Context (Level 1)
- The system in the center
- Users (personas) around it
- External systems it integrates with
- Relationships and protocols

### 2. C4 Diagram — Containers (Level 2)
- Applications, services, databases, queues, caches
- Technology of each container
- Communication between containers

### 3. C4 Diagram — Components (Level 3)
- For the most relevant containers
- Internal components and responsibilities

### 4. C4 Diagram — Code (Level 4, only when necessary)
- Generate **only if** `doc_level` is `detailed` **and** a component is complex enough to warrant class-level detail (e.g. intricate inheritance, many interrelated classes, or non-obvious design patterns)
- Target the single most complex component; do not diagram every class in the project
- Classes, interfaces, key methods and their relationships
- Use Mermaid classDiagram syntax
- If no component meets the complexity threshold, skip this level entirely and note the reason in `architecture.md`

### 5. Complete ERD
- All entities with main attributes
- Relationships with cardinalities (1:1, 1:N, N:M)
- Primary and foreign keys

### 6. External integrations
- REST/GraphQL APIs consumed and produced
- Webhooks, events, messages
- Protocols and data formats

### 7. Technical debt
- Duplicated code
- Inconsistent patterns
- Critical outdated dependencies
- Lack of tests in critical modules

### 8. Spec Impact Matrix
Create `_reversa_sdd/traceability/spec-impact-matrix.md`: which component impacts which.

## Output

**Always:**
- `_reversa_sdd/architecture.md` — architectural overview (if `essential`: includes embedded C4 context and summarized ERD when there are fewer than 5 entities)
- `_reversa_sdd/c4-context.md` — C4 Context diagram in Mermaid

**Only if `doc_level` is `complete` or `detailed`:**
- `_reversa_sdd/c4-containers.md` — C4 Containers diagram in Mermaid
- `_reversa_sdd/c4-components.md` — C4 Components diagram in Mermaid
- `_reversa_sdd/erd-complete.md` — ERD in Mermaid (if `essential`: embed in architecture.md)
- `_reversa_sdd/traceability/spec-impact-matrix.md` — component impact matrix

**Only if `doc_level` is `detailed`:**
- `_reversa_sdd/deployment.md` — infrastructure and deployment diagram (if Dockerfile, docker-compose or cloud configs are identified)
- `_reversa_sdd/c4-code.md` — C4 Code (Level 4) class diagram for the most complex component, in Mermaid classDiagram syntax (only if a component is complex enough; otherwise omit and note the reason in `architecture.md`)

## Confidence scale
🟢 CONFIRMED | 🟡 INFERRED | 🔴 GAP

## Output layout (cross-cutting)

This agent produces cross-cutting artifacts relative to the organization chosen in `[specs]` of `config.toml`. Files stay in the root of `<output_folder>/`, outside unit folders (feature folders). Do not apply the `<unit>/requirements.md|design.md|tasks.md` structure here, it belongs to the Writer.

Inform the Reversa: components, containers, integrations and technical debt identified.
