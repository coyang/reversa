# Contributing to Reversa

Thank you for considering a contribution! Reversa is a multi-language framework (the codebase, the documentation, and the spec output all support **English / 中文 / Português / Español**), so contributions span code, prompts, documentation, and translations.

[中文版本 / Chinese version](./CONTRIBUTING.zh.md)

---

## Table of contents

- [Ways to contribute](#ways-to-contribute)
- [Repository layout (what lives where)](#repository-layout-what-lives-where)
- [Local development setup](#local-development-setup)
- [Editing agent prompts (SKILL.md)](#editing-agent-prompts-skillmd)
- [Adding or improving translations](#adding-or-improving-translations)
- [Adding a new locale](#adding-a-new-locale)
- [Pull-request checklist](#pull-request-checklist)
- [Coding & prompt style](#coding--prompt-style)
- [Release process](#release-process)

---

## Ways to contribute

| Type | Examples |
|---|---|
| **Bug report** | Installer crash, agent producing wrong output, malformed `state.json` |
| **Feature** | New agent, new orchestrator command, new template |
| **Prompt improvement** | Better instruction in a `SKILL.md`, better edge-case handling |
| **Translation** | Add or polish a `*.zh.md` / `*.pt.md` / `*.es.md` doc; extend `GLOSSARY.zh.md` |
| **New locale** | Add a 5th language (e.g. `ja`, `fr`, `de`) following the [Adding a new locale](#adding-a-new-locale) guide |
| **Documentation** | Improve `README.md`, `docs/**`, add diagrams |
| **CI / tooling** | npm scripts, mkdocs build, link checks |

Before opening a PR for anything non-trivial, please **open an issue first** to discuss the approach. This avoids wasted work.

---

## Repository layout (what lives where)

```
reversa/
├── agents/                # Agent prompts (SKILL.md) — the heart of the framework
│   ├── reversa/           #   Main orchestrator
│   ├── reversa-scout/     #   Discovery: surface inventory
│   ├── reversa-writer/    #   Generates spec files
│   └── ...                #   ~49 agents total
├── bin/reversa.js         # CLI entry point
├── lib/
│   ├── commands/          # `install`, `update`, `status`, `uninstall`, …
│   ├── installer/         # Prompts, detector, writer, manifest, validator
│   └── utils/             # Banner, json-safe, etc.
├── templates/             # Files copied INTO the user's project
│   ├── state.json         #   .reversa/state.json template
│   ├── config.toml        #   .reversa/config.toml template
│   ├── config.user.toml   #   .reversa/config.user.toml template
│   ├── documentation/     #   HTML mini-site templates for /reversa-docs
│   ├── forward/           #   Body templates for /reversa-forward
│   └── migration/         #   Templates for /reversa-migrate
├── docs/                  # mkdocs site source
│   ├── *.md               #   Base locale (English)
│   ├── *.zh.md            #   Simplified Chinese
│   ├── *.pt.md            #   Portuguese
│   └── *.es.md            #   Spanish
├── mkdocs.yml             # mkdocs config with i18n plugin
├── package.json
├── CHANGELOG.md
└── README.md
```

**Important contracts** (do not break unless you really know what you are doing):
- `state.json` phase field values (`recognition`, `excavation`, …) — use the English forms; legacy Portuguese values (`reconhecimento`, `escavacao`) are auto-converted. Pricing-related JSON keys like `preco_minimo` remain as-is, shared by 50+ agents.
- File / folder names of agents and templates are referenced literally inside prompts. Renaming requires updating every reference.
- `.reversa/` and `_reversa_sdd/` are the **only** paths agents are allowed to write to. Never widen this.

---

## Local development setup

```bash
git clone https://github.com/sandeco/reversa.git
cd reversa
npm install
npm link        # registers `reversa` globally as a symlink to this repo
```

Now in any other (legacy) project:

```bash
cd /path/to/legacy-project
reversa install      # use the bare command — NOT `npx reversa`
```

Changes you make to any `agents/**/SKILL.md`, `templates/**`, or `lib/**` are picked up on the **next** `reversa install` in the target project, without re-linking.

To unlink:

```bash
cd /path/to/reversa
npm unlink -g reversa
```

See `README.md` → "Development mode" for verification commands and alternative install methods.

### Running the docs site locally

```bash
pip install mkdocs mkdocs-material mkdocs-static-i18n
mkdocs serve     # http://127.0.0.1:8000/   (English)
                 # http://127.0.0.1:8000/zh/ (Chinese)
                 # http://127.0.0.1:8000/pt/ (Portuguese)
                 # http://127.0.0.1:8000/es/ (Spanish)
```

---

## Editing agent prompts (SKILL.md)

Reversa is fundamentally a **prompt engineering** project. Each `SKILL.md` is the operating manual for one AI agent. Some house rules:

1. **Keep `SKILL.md` in English.** Multilingual examples inside the prompt are fine (and encouraged), but the prompt structure itself stays English. Translating the whole SKILL into another language tends to degrade LLM reasoning quality.
2. **Front-matter is contract.** The YAML at the top of each SKILL is parsed by some engines. Do not break:
   - `name: <agent-id>` must match the folder name
   - `description: ...` is shown to the user
   - `compatibility: ...` lists engines
3. **Language Contract block.** Every SKILL must include the "Language Contract" section that reads `chat_language` and `doc_language` from `.reversa/state.json`. Use the existing SKILLs as templates (search for "Language Contract" or "doc_language is 中文").
4. **Reference files** under `agents/<agent>/references/*.md` should also stay English-first; user-facing labels can be multilingual.
5. **Do not introduce new control keywords** that are language-specific. Use [`agents/reversa/references/confirmation-keywords.md`](agents/reversa/references/confirmation-keywords.md).
6. **Test in at least two engines** before submitting (e.g. Claude Code + Codex).

---

## Adding or improving translations

### Documentation (`docs/`)

- File naming: `name.md` (English base), `name.pt.md`, `name.zh.md`, `name.es.md`.
- The mkdocs-static-i18n plugin auto-routes them; you do **not** need to register each new file in `mkdocs.yml`. You **do** need to add nav-translation entries if you change a navigation label.
- When adding a `name.zh.md`, run a quick parity check: line count and section headings should roughly mirror `name.md`. Significant divergence is a smell.

### Terminology

- Update [`agents/reversa/references/GLOSSARY.zh.md`](agents/reversa/references/GLOSSARY.zh.md) **before** translating prose. Consistency matters more than poetry.
- Heading translations belong in the "Spec 标题映射表" section of the same file.

### Generated spec output

- Spec content language is controlled by `doc_language` in `state.json`. Translation rules belong in agent SKILLs (Language Contract) and the glossary, not hard-coded.

### Translation review

- We accept PRs from non-native speakers, but reviewers should be native. Tag `@sandeco` if no native reviewer is available.
- Machine-translation-only PRs (without human polish) will not be merged. Use MT as a draft, then revise.

---

## Adding a new locale

Want to add, say, Japanese? Here is the full checklist:

1. **`lib/installer/prompts.js`** — add new option to `chat_language` and `doc_language` choices.
2. **`templates/state.json`, `templates/config.toml`** — leave defaults (`zh-cn`/`中文`) or document the new locale in comments.
3. **`agents/reversa/SKILL.md`** Language Contract — add the new locale to the rules table.
4. **`agents/reversa/references/GLOSSARY.{lang}.md`** — create a glossary for the new locale (copy `GLOSSARY.zh.md` structure).
5. **`agents/reversa/references/confirmation-keywords.md`** — add the new locale's `continue` / `stop` keywords.
6. **`mkdocs.yml`** — add `- locale: <lang>` block under `plugins.i18n.languages` with complete `nav_translations`.
7. **`docs/*.<lang>.md`** — translate all 39 base-locale `.md` files. (You can land in batches.)
8. **`README.md`** — add a docs badge linking to `https://sandeco.github.io/reversa/<lang>/`.
9. **`CHANGELOG.md`** — add an entry under the next version.
10. **`templates/documentation/assets/css/style.css`** — if the locale needs special fonts (CJK, RTL, …), extend the font stacks.

---

## Pull-request checklist

Before opening a PR:

- [ ] Branch is up to date with `main`
- [ ] Commits are atomic, with messages following the pattern `<type>: <short description>` (`feat: …`, `fix: …`, `docs: …`, `chore: …`, `i18n: …`, `prompt: …`)
- [ ] If you changed `agents/**`, you ran `reversa install` against a sample legacy project and visually verified the output
- [ ] If you changed `templates/state.json` or `templates/config.toml`, you also updated `agents/reversa/references/state-schema.md`
- [ ] If you added a new agent, you added it to:
  - `lib/installer/prompts.js` (team mapping)
  - `agents/reversa/SKILL.md` (orchestrator's plan)
  - `docs/agentes/<agent>.md` (and `.zh.md` / `.pt.md` / `.es.md` translations)
- [ ] If you changed any user-visible string in an English SKILL or doc, translations are updated **or** you explicitly note "translations to follow in a separate PR"
- [ ] `mkdocs build --strict` passes (no broken links / missing nav entries)
- [ ] `CHANGELOG.md` has an entry under `## [Unreleased]` (create the section if missing)

---

## Coding & prompt style

- **JS / Node**: ESM only (`type: "module"` in `package.json`). No CommonJS.
- **Python (scripts under `templates/` and `agents/*/scripts/`)**: target Python 3.10+, use type hints, docstrings in English.
- **Markdown**: ATX headings (`#`), fenced code blocks with language tag (`` ```python ``), reference-style links allowed for repeated URLs.
- **Prompts**: prefer numbered steps for procedures, bullet lists for invariants. Avoid hedging language ("you may want to consider…") — agents need clear directives.
- **Filenames**: ASCII only, lowercase, hyphen-separated. Never use spaces, accents, or non-ASCII characters in paths.

---

## Release process

Maintainers only:

1. Bump `package.json` `version` following SemVer
2. Add the new section to `CHANGELOG.md`
3. Tag: `git tag v1.x.y && git push --tags`
4. `npm publish --access public`
5. mkdocs is deployed via GitHub Pages on push to `main`

---

## Code of conduct

Be kind, be specific, assume good faith. We follow the [Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

---

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](./LICENSE).
