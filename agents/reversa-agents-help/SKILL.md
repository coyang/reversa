---
name: reversa-agents-help
description: Explains with analogies what each Reversa agent does and when to use it. Activate with /reversa-agents-help.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  role: help
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


Present exactly the text below, without alterations, without summarizing.

---

# Reversa Agents — guide with analogies

Reversa is a team of specialists. Each agent does one thing — and does it well.

---

## Reversa — central orchestrator
**Command:** `/reversa`

An orchestra conductor plays no instrument. They know the entire score and tell who enters when, in what order, at what tempo. Without them, each musician would play their part without connecting with the others.

> Use Reversa to start or resume the complete analysis. It handles the sequence for you.

---

## Scout — the real estate agent
**Command:** `/reversa-scout`

The agent does the first tour of the property. Doesn't open drawers, doesn't read documents, doesn't touch anything. Just maps: how many rooms, what neighborhood, what facilities exist, what the general condition is.

> Use Scout at the beginning. It generates the project inventory — languages, frameworks, modules, dependencies — without getting into the code.

---

## Soul Extractor: the express biographer
**Command:** `/reversa-extract-soul`

The express biographer visits the subject, reads the agent's notes (Scout), quickly browses some family albums and the history of letters (git log), and produces a one-page biography: who they are, what they do, and the founding decisions that shaped their entire life. It's not the complete story, it's the distilled soul.

> Use Soul Extractor right after Scout, when you want an executive synthesis of the system (purpose, central entities, and founding decisions) in a single Spec, without waiting for the entire pipeline. Does not replace Archaeologist or Detective.

---

## Archaeologist — the excavator
**Command:** `/reversa-archaeologist`

The archaeologist excavates the terrain patiently, layer by layer. Catalogs each artifact found: size, material, location, shape. They don't interpret the civilization, they only precisely describe what is there.

> Use Archaeologist to analyze the code module by module. It extracts functions, algorithms, data structures, and control flows. **Runs one module per session** to save tokens.

---

## Detective — Sherlock Holmes
**Command:** `/reversa-detective`

Sherlock Holmes arrives after the archaeologist. Looks at the cataloged artifacts and asks: *"But why is this here? Who put it here? What does this reveal about who lived here?"* They don't excavate. They interpret.

> Use Detective after Archaeologist. It extracts implicit business rules, reads the git history as a diary, and reconstructs decisions that no one documented.

---

## Architect — the cartographer
**Command:** `/reversa-architect`

The cartographer visits a territory and produces formal maps: floor plan, elevation map, structural plan. Someone who has never been there can understand everything by looking at the maps.

> Use Architect after Detective. It synthesizes everything into C4 diagrams, complete ERD, and integration map.

---

## Writer — the notary
**Command:** `/reversa-writer`

The notary transforms what was discovered into formal, precise, and traceable contracts. Each clause has a declared degree of certainty. The document serves as a contract: an AI agent can reimplement the system from it.

> Use Writer after Architect. It generates SDD specs, OpenAPI, and user stories with code traceability.

---

## Reviewer — the spec reviewer
**Command:** `/reversa-reviewer`

The Reviewer takes the Writer's contracts and tries to poke holes: *"This is a contradiction. This point has no proof. This rule disappears if the user does X."* They don't want to destroy, they want to ensure that what remains standing is solid.

> Use Reviewer after Writer. It critically reviews specs, reclassifies confidence, and raises questions for human validation.

---

## Visor — the forensic illustrator
**Command:** `/reversa-visor`

The forensic illustrator works only with images. Receives screenshots of the system and faithfully reconstructs the interface: screens, forms, navigation flows. Doesn't need the system to be running — just the photos.

> Use Visor when screenshots are available. It documents the UI without needing system access.

---

## Data Master — the geologist
**Command:** `/reversa-data-master`

The geologist maps the subsoil — the layer no one sees but that supports everything. Tables, relationships, constraints, triggers, procedures. The invisible foundation upon which the application is built.

> Use Data Master when DDL, migrations, or ORM models are available. It documents the database completely.

---

## Design System — the stylist
**Command:** `/reversa-design-system`

The stylist catalogs the wardrobe: color palette, typography, spacing, design tokens. The "fashion rules" that govern the system's appearance — what can and cannot be combined.

> Use Design System when CSS files, themes, or interface screenshots are available. It extracts the project's visual tokens.

---

## Recommended sequence

```
/reversa → orchestrates everything automatically

Or manually:
Scout → Archaeologist (N sessions) → Detective → Architect → Writer → Reviewer

Optional at any phase:
Soul Extractor · Visor · Data Master · Design System
```
