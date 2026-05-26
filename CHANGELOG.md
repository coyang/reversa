# Changelog

All notable changes to Reversa will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.3.0] — 2026-05-25

### Added

- **Autopilot Mode**: The framework now supports skipping the manual `CONTINUE` prompts between generated artifacts or agents. Controlled by the `autopilot` field in `.reversa/state.json` (`off`, `unit`, or `full`). See `agents/reversa/references/autopilot-mode.md` for details.
  - The installer now asks for the autopilot preference.
  - All 26 orchestration and generation skills have been updated to respect this setting.
- **First-class Simplified Chinese (zh-cn) support** across the entire framework.
  - Installer prompts now offer a 4-option locale picker (中文 / English / Português / Español) instead of free-text input.
  - `templates/state.json`, `templates/config.toml`, and `templates/config.user.toml` now default to `chat_language = "zh-cn"` and `doc_language = "中文"`.
- **Language Contract** section added to every agent's `SKILL.md` (49/49 SKILL files updated). Agents now read `chat_language` and `doc_language` from `.reversa/state.json` and apply them consistently to chat and to written artifacts.
- **Chinese terminology glossary**: new [`agents/reversa/references/GLOSSARY.zh.md`](agents/reversa/references/GLOSSARY.zh.md) defines:
  - Canonical Chinese translations for ~150 framework / domain / engineering terms.
  - Full spec-heading mapping (requirements / design / tasks / plan / clarify / audit / inventory / soul) so all writer agents produce consistent Chinese headings.
- **Multilingual confirmation keywords**: new [`agents/reversa/references/confirmation-keywords.md`](agents/reversa/references/confirmation-keywords.md) — orchestrators accept `CONTINUE / 继续 / CONTINUAR / SIGUIENTE` (and short forms `y / yes / 是 / sim / sí`) interchangeably.
- **mkdocs Chinese locale**: `mkdocs.yml` adds `locale: zh` with full nav_translations (58 entries). Site is now buildable at `/zh/`.
- **39 Chinese documentation files**: `docs/**/*.zh.md` covers 100% of the English documentation set (parity with pt/es locales).
- **Chinese documentation badge** in `README.md`.
- **Development mode guide** in `README.md`: complete `npm link` workflow for running a local fork against legacy projects, including verification, hot-reload behavior, unlink steps, and 3 alternative install methods (direct bin call, local-path npm install, tarball).
- **CJK font stack** added to `templates/documentation/assets/css/style.css` across all three themes (Sober, Vibrant, Dark) — falls back through Inter → PingFang SC → Microsoft YaHei → Noto Sans CJK SC for body, headings, and monospace.

### Changed

- **Folder naming rule (BREAKING for any tool that assumed localized folder names)**: [`agents/reversa-writer/SKILL.md`](agents/reversa-writer/SKILL.md) "RF-10" now mandates that **all generated folder and file names are ASCII**, regardless of `doc_language`. Chinese installs use English nouns or hyphenless Hanyu Pinyin (e.g. `user-auth/`, `orders/`, `zhifu/`). Only file *contents* follow `doc_language`. This guarantees cross-platform compatibility (Windows / macOS / Linux), URL-safety, and git portability.
- **Installer prompts default**: `chat_language` defaults to `zh-cn`, `doc_language` defaults to `中文`. Other locales remain one keystroke away.
- **`spec_scorer.py` vague-term list**: extended to recognize both English and Chinese vague phrases.
- **`reversa-n8n` SKILL**: default `chat_language` / `doc_language` now align with the new state defaults.

### Translated

- All agent `SKILL.md` (49 files) — original Portuguese / mixed-language content translated to English with embedded multilingual examples (Chinese / English).
- All `agents/*/references/**/*.md` — reference docs, error catalogs, schemas, examples (including [`ARCH_TOUR.md`](agents/reversa-arquitetura-3d/references/ARCH_TOUR.md), [`CODE_CITY.md`](agents/reversa-arquitetura-3d/references/CODE_CITY.md), [`LAYER_STACK.md`](agents/reversa-arquitetura-3d/references/LAYER_STACK.md), [`THREE_PATTERNS.md`](agents/reversa-arquitetura-3d/references/THREE_PATTERNS.md), [`HIGHCHARTS_PATTERNS.md`](agents/reversa-highcharts-visualizer/references/HIGHCHARTS_PATTERNS.md), [`CHART_CATALOG.md`](agents/reversa-highcharts-visualizer/references/CHART_CATALOG.md), all pricing references, all selo-generativo references).
- All `agents/*/scripts/*.py` — docstrings, comments, error messages, sample-data labels.
- All `templates/**/*.{md,yaml,html,tpl,py,js,css}` — body content English, file names preserved (e.g. `arquitetura.html.tpl`, `instalacao.md`).
- `lib/installer/prompts.js` — UI strings.
- `README.md` and base-locale `docs/*.md`.

### Preserved (intentional, do not change)

- **Portuguese identifiers in JSON / state schemas**: keys like `preco_minimo`, `horas_estimadas`, `tax_factor`, `reconhecimento`, `escavacao` are runtime-consumed contracts shared by 50+ agents; changing them would cause cascading breakage.
- **Portuguese folder / file names** under `agents/reversa-arquitetura-3d/`, `agents/reversa-especialista-d3/`, `agents/reversa-selo-generativo/`, `docs/migracao/`, `templates/documentation/pages/arquitetura.html.tpl`, etc. — referenced literally by many agents.
- **Bilingual regex** in [`spec_scorer.py`](agents/reversa-spec-sdd/scripts/spec_scorer.py): `(o sistema|o usuário|a plataforma|the system|the user)` — supports detecting both Portuguese and English user input.
- **`.pt.md` and `.es.md` documentation files**: untouched, remain in their native languages.
- **`mkdocs.yml` `nav_translations`** for pt/es locales: legitimate i18n configuration.

### Migration notes

If you are upgrading from `1.2.x`:
- Existing installations are **not auto-migrated**. To pick up the new defaults, run `reversa install` and answer "yes" to the re-install prompt. Your `.reversa/state.json` (analysis progress) is preserved.
- If you scripted reads of folder names assuming they would be localized, update those scripts to expect ASCII names regardless of locale.
- If you relied on the `1.2.47` Portuguese-by-default behavior, explicitly choose `Português` in the installer locale picker, or set `chat_language = "pt-br"` and `doc_language = "Portuguese"` in `.reversa/state.json` before first run.

---

## [1.2.47] and earlier

See git history. This file starts tracking changes from `1.3.0`.
