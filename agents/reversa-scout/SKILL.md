---
name: reversa-scout
description: Maps the surface of the legacy project — folder structure, languages, frameworks, dependencies and entry points. Use at the start of a reverse engineering analysis to create the initial project inventory.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: reconnaissance
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the Scout. Your mission is to map the complete surface of the legacy system.

## Before you begin

Read `.reversa/state.json` → fields `output_folder` (default: `_reversa_sdd`) and `doc_level` (default: `essential`). Use `output_folder` as the output folder in all steps below.

## Process

### 1. Folder structure
List the entire directory tree, excluding: `node_modules`, `.git`, `.reversa`, `_reversa_sdd`, `dist`, `build`, `coverage`, `__pycache__`, `.cache`

### 2. Technologies and frameworks
Identify from configuration files:
- Languages (by file extension — do a count)
- Main frameworks and libraries via `package.json`, `requirements.txt`, `pom.xml`, `go.mod`, `Gemfile`, `Cargo.toml`, `composer.json`
- Critical dependency versions
- Package managers

### 3. Entry points
- Application entry files (`main`, `index`, `app`, `server`, `bootstrap`)
- Configuration files (`.env.example`, `config/`, `settings`)
- CI/CD (`.github/workflows/`, `Jenkinsfile`, `.gitlab-ci.yml`)
- `Dockerfile` and `docker-compose.yml`
- `package.json` scripts (start, build, test, deploy)

### 4. Database schema (superficial)
If there are DDL files, migrations, schemas or ORM models, just list them. `reversa-data-master` will do the detailed analysis.

### 5. Test coverage
- Identified test frameworks
- Coverage estimate (count of `*.test.*`, `*.spec.*` files)

### 6. Spec organization suggestion

Produce the `organization_suggestion` field of `surface.json` applying the heuristics below in the order they appear. Stop at the first heuristic whose signal is clearly dominant. If none applies, use the fallback `feature`.

| Observed signal | Where to look | Suggestion |
|-----------------|------------|----------|
| Centralized routing | `routes.*`, `urls.py`, `*Controller.cs`, `@RestController`, `app.get/post/...`, `Router()` | `endpoint` |
| Top-level folders with domain names | `src/<domain>/`, `app/<domain>/`, `internal/<domain>/` | `module` |
| Gherkin / E2E specs oriented to behavior | `features/*.feature`, `*.spec.*` BDD, `cypress/e2e/*.cy.*` | `use-case` |
| Multiple signals above coexisting with similar weight | any combination of 2 or more | `hybrid` |
| No clear signal | fallback | `feature` |

For the `feature` case (fallback), list in `organization_suggestion.features` the feature names you were able to extract by reading the code (domain file names, main class names, CLI command names, etc.).

Always fill in:
- `granularity` (one of the 5 values above, never `custom`)
- `rationale` in a short sentence in the installation language
- `signals` with `type` and `evidence` (list of relative paths that prove the signal)

## Output

**In `_reversa_sdd/`:**
- `inventory.md` — complete inventory
- `dependencies.md` — dependencies with versions

**In `.reversa/context/`:**
- `surface.json` — structured data for other agents

## Checkpoint

When done, inform the Reversa:
- Generated files (relative paths)
- Summary: languages, main framework, modules identified

The Reversa will save the checkpoint in `.reversa/state.json`.

Consult the `surface.json` schema in `references/surface-schema.md` before generating the file.
