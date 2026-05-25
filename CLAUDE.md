# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Reversa is an npm package that installs into legacy projects and coordinates AI agents (Claude Code, Cursor, Codex, etc.) to reverse-engineer specifications from existing code. The "runtime" is the AI agents themselves reading SKILL.md prompts — the Node.js CLI is purely an installer/scaffolder.

## Development Commands

```bash
# No build step — pure ESM Node.js (>=18.20.2)
npm install

# Run the CLI locally
node bin/reversa.js --help
node bin/reversa.js install

# Documentation site (MkDocs Material, trilingual EN/PT/ES)
mkdocs serve

# Publish to npm (maintainer only)
npm publish
```

No test suite, linter, or CI/CD pipeline exists.

## Architecture

**The CLI (`lib/`)** is a thin installer — it never runs agents, only copies their SKILL.md files into target projects.

- `bin/reversa.js` — CLI entry point, dispatches to commands via dynamic imports
- `lib/commands/` — `install`, `update`, `uninstall`, `status`, `add-agent`, `add-engine`, `export-diagrams`
- `lib/installer/detector.js` — auto-detects which of 13 AI engines are present (Claude Code, Cursor, Codex, Gemini CLI, Windsurf, etc.)
- `lib/installer/writer.js` — `Writer` class that copies agent skills and creates `.reversa/` structure in target projects
- `lib/installer/manifest.js` — SHA-256 manifest for safe updates (never overwrites user-modified files)
- `lib/installer/prompts.js` — interactive inquirer prompts; defines agent team rosters
- `lib/utils/` — `banner.js` (ASCII art), `json-safe.js` (BOM-tolerant JSON reader)

**Agents (`agents/`)** — ~49 directories (`reversa-<name>/`), each containing a `SKILL.md` (YAML frontmatter + markdown prompt). These are the "code" — AI agents read and execute the prompts. Agents may also have `references/`, `scripts/`, or `assets/` subdirectories.

**Templates (`templates/`)** — scaffold files installed into target projects:
- `engines/` — entry files per AI engine (CLAUDE.md, AGENTS.md, .cursorrules, GEMINI.md, etc.)
- `forward/` — forward pipeline templates (body markdown, shell/PowerShell scripts, hooks.yml, setup.json)
- `migration/` — migration artifact templates and strategy/paradigm catalogs
- `documentation/` — HTML mini-site templates with CSS, JS, and Python extraction scripts

## Key Design Rules

- **Immutability**: The installer never modifies or deletes pre-existing project files. Output goes only to `.reversa/`, `_reversa_sdd/`, and `_reversa_forward/`.
- **SHA-256 manifest tracking**: Every installed file is hashed. The `update` command respects user modifications.
- **Agent skills are pure markdown**: No traditional runtime — the AI agent reads SKILL.md and follows instructions.
- **Multi-engine support**: 13 AI engines supported via pluggable detection/installation (each defines entry file, skills dir, universal skills dir).

## Agent Teams and Entry Commands

| Team | Entry Command | Key Agents |
|------|--------------|------------|
| Discovery Core | `/reversa` | scout, archaeologist, detective, architect, writer, reviewer |
| Migration | `/reversa-migrate` | migrate, paradigm-advisor, curator, strategist |
| Code Forward | `/reversa-forward` | forward, requirements, clarify, plan, to-do, audit, coding |
| New Project | `/reversa-new` | new, ideator, researcher, drafter, spec-sdd |
| Documentation | `/reversa-docs` | docs, docs-mapper, docs-analyst, docs-storyteller, docs-publisher |
| Pricing | `/reversa-pricing-*` | pricing-profile, pricing-size, pricing-estimate |
| Translators | `/reversa-n8n` | N8N workflow analyzer |

## Conventions

- ESM module (`"type": "module"`) — use `import`/`export`, `import.meta.url`, `fileURLToPath`
- Code comments and CLI output are primarily in Portuguese (pt-br)
- Commit messages follow conventional commits: `feat()`, `fix()`, `docs()`, `chore()`, `refactor()`
- Version bumps are dedicated commits: `chore(release): bump reversa to X.Y.Z`
- Dependencies are production-only (no devDependencies): chalk, inquirer, ora, semver
