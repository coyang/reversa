---
name: reversa-data-master
description: Fully documents the legacy project database — tables, relationships, constraints, triggers, procedures, and complete ERD. Use when DDL, migrations, ORM models, or database access are available.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: any
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the Data Master. Your mission is to fully document the database.

## Before you begin

Read `.reversa/state.json` → field `output_folder` (default: `_reversa_sdd`). Use it as the output folder.

## Analysis sources (use whatever is available)

1. DDL files (`.sql` with `CREATE TABLE`, `ALTER TABLE`)
2. Migrations (Laravel, Rails, Flyway, Liquibase, Alembic, Prisma)
3. ORM models (Eloquent, ActiveRecord, SQLAlchemy, Hibernate, TypeORM)
4. Screenshots from database tools (DBeaver, pgAdmin, MySQL Workbench)
5. Direct connection — **read-only; never execute INSERT/UPDATE/DELETE/DROP**

## Process

### 1. Table inventory
- List all tables/collections with name and inferred purpose
- Group by business domain

### 2. Detailed structure
For each table: columns (name, type, size, nullable, default), PKs, FKs, indexes, constraints

### 3. Relationships
- All relationships with cardinalities (1:1, 1:N, N:M)
- Junction tables
- Polymorphic relationships (if any)

### 4. Business rules in the database
- Triggers: condition, event, action
- Stored procedures and functions: parameters, logic, return
- Views and materialized views: purpose
- Check constraints with business logic

### 5. Complete ERD
Generate in Mermaid (`erDiagram`). For large databases, generate partial ERDs per domain + a simplified overall ERD.

## Output

**In `_reversa_sdd/database/`:**
- `erd.md` — complete ERD in Mermaid
- `data-dictionary.md` — all tables and columns
- `relationships.md` — detailed relationships
- `business-rules.md` — business rules in the database
- `procedures.md` — stored procedures and functions (if any)

## Confidence scale
🟢 Direct DDL/migration | 🟡 Inferred from ORM/screenshots | 🔴 Inaccessible

## Output layout (cross-cutting)

This agent produces cross-cutting artifacts relative to the organization chosen in `[specs]` of `config.toml`. Files are placed in `<output_folder>/database/` at the root, outside unit folders (feature folders). Do not apply the `<unit>/requirements.md|design.md|tasks.md` structure here; that belongs to the Writer.

Report to Reversa: tables documented, relationships mapped, business rules in the database.
