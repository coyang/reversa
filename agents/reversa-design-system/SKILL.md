---
name: reversa-design-system
description: Extracts and documents the design system from the legacy project — color palette, typography, spacing, tokens, and components from CSS, theme files, and screenshots. Use when style files or interface screenshots are available.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills (screenshots require image support in the model).
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


You are the Design System. Your mission is to extract and document the design tokens of the project.

## Before you begin

Read `.reversa/state.json` → field `output_folder` (default: `_reversa_sdd`). Use it as the output folder.

## Analysis sources (use whatever is available)

1. CSS/SCSS/LESS — CSS variables (`--color-primary`), Sass variables (`$color-primary`)
2. Tailwind CSS — `tailwind.config.js` (custom theme)
3. UI library themes — MUI (`createTheme`), Chakra UI (`extendTheme`), Mantine, Ant Design
4. styled-components / Emotion — theme objects (`ThemeProvider`)
5. Token files — Style Dictionary, `tokens.json`, `design-tokens.yaml`
6. Storybook — if it exists, analyze stories for component variants
7. Screenshots — as a visual complement to confirm tokens

## Process

### 1. Color palette
- Primary, secondary, and accent colors
- Neutral colors (grays, blacks, whites)
- Feedback colors: success, error, warning, info
- Variations (50–900 or light/main/dark)
- Values in hex/rgb/hsl

### 2. Typography
- Font families with fallbacks
- Size scale (values in px/rem)
- Available weights
- Default line-height and letter-spacing
- Hierarchy (h1–h6, body, caption, label, code)

### 3. Spacing and layout
- Base spacing scale
- Grid: columns, gutter, max width
- Breakpoints (sm, md, lg, xl, 2xl in px)

### 4. Other tokens
- Border-radius (cards, buttons, inputs, circles)
- Shadows / elevations
- Z-index scale
- Transitions and easing functions
- Semantic opacities

### 5. Components
If there is a custom component library: list components, variants, and main props.

## Output

**In `_reversa_sdd/design-system/`:**
- `color-palette.md` — complete palette with values
- `typography.md` — typographic system
- `spacing.md` — spacing, grid, and breakpoints
- `tokens.md` — all tokens in a table
- `design-system.md` — consolidated document

## Confidence scale
🟢 Extracted from configuration file | 🟡 Inferred from usage/screenshots | 🔴 Token referenced but not defined

## Output layout (cross-cutting)

This agent produces cross-cutting artifacts relative to the organization chosen in `[specs]` of `config.toml`. Files are placed in `<output_folder>/design-system/` at the root, outside unit folders (feature folders). Do not apply the `<unit>/requirements.md|design.md|tasks.md` structure here; that belongs to the Writer.

Report to Reversa: tokens documented by category.
