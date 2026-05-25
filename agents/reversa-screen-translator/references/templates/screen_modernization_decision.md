---
schemaVersion: 1
generatedAt: <ISO-8601>
reversa:
  version: "x.y.z"
kind: screen_modernization_decision
producedBy: screen-translator
decidedBy: <human-id or null when mode=skipped>
decidedAt: <ISO-8601 or null when mode=skipped>
mode: literal | modernized | hybrid | skipped
sourcePlatform: <slug or null when mode=skipped>
targetPlatform: <slug or null when mode=skipped>
hash: "sha256:<hash of body below front-matter>"
---

> When `mode: skipped`, this decision **did not go through a human**: it was automatically emitted by the Screen Translator because the legacy has no UI. Only the "Context" and "Decision" sections are filled, with the reason for the omission; the rest remains N/A. The Inspector reads `mode: skipped` in the front-matter and skips visual parity without asking.


# Screen Modernization Decision

> Conscious decision on how to translate the legacy system screens: observable byte-by-byte parity, idiomatic redesign for the target platform, or combination screen-by-screen.
> This artifact is mandatory reading for the Screen Translator itself (to generate `target_screens.md`), the Inspector (to build appropriate parity tests for the mode), and the coding agent.

## Context

- **Detected source platform**: <slug> (e.g., `cobol-ansi-tui`, `delphi-vcl`, `asp-classic`, `android-xml`)
- **Confidence**: 🟢 CONFIRMED | 🟡 INFERRED | 🔴 GAP | ⚠️ AMBIGUOUS
- **Target platform**: <slug> (e.g., `go-cli`, `web-spa`, `flutter`, `tauri`)
- **Screens inventoried**: <N>
- **Inventory origin**: `_reversa_sdd/screens/inventory.json` + `_reversa_sdd/ui/inventory.md`
- **Applied adapter**: `<adapters/source__target>` (see `references/adapter-pairs.md`)

## Evaluated modes

### Mode: literal
- **Definition**: observable byte-by-byte or pixel-equivalent parity between legacy and new.
- **Trade-offs**:
  - Implementation cost: <high | medium | low>
  - Visual fidelity: <high | medium | low>
  - Viability of constructive parity tests: <yes | partial | no>
  - Expected end-user acceptance: <high | medium | low>
  - Future technical debt: <high | medium | low>
- **Recommended**: <yes | no>
- **Justification**: <short text>

### Mode: modernized
- **Definition**: idiomatic redesign for the target platform, preserving information and flow, but re-expressing hierarchy and interaction.
- **Trade-offs**:
  - Implementation cost: <high | medium | low>
  - Visual fidelity: <high | medium | low>
  - Viability of constructive parity tests: <yes | partial | no>
  - Expected end-user acceptance: <high | medium | low>
  - Future technical debt: <high | medium | low>
- **Recommended**: <yes | no>
- **Justification**: <short text>

### Mode: hybrid
- **Definition**: some screens in literal, some in modernized, with explicit lists.
- **Trade-offs**:
  - Implementation cost: <high | medium | low>
  - Mixed visual fidelity: <description>
  - Parity test viability: <description per subset>
  - Maintenance cost of the separation: <high | medium | low>
- **Recommended**: <yes | no>
- **Justification**: <short text>

## Decision

- **Chosen mode**: <literal | modernized | hybrid>
- **Human justification**: <text>
- **Discarded alternatives**: <brief list with reason>
- **Decided at**: <ISO-8601>
- **Decided by**: <name or identifier>

### In hybrid mode, explicit lists (mandatory)

**Screens in literal mode**:
- <screen 1>
- <screen 2>

**Screens in modernized mode**:
- <screen 3>
- <screen 4>

> Empty lists block Phase 2. The agent refuses to proceed.

## Pending implications for Phase 2

| Stage | Implication | How to honor |
|---|---|---|
| Generation of `target_screens.md` | <implication> | <expected action> |
| Golden file capture | <implication> | <expected action> |
| Design-system tokens | <implication> | <expected action> |
| Textual content | Preserve literally unless explicit linguistic revision approval | <expected action> |

## Implications for the Inspector

- **Parity strategy**:
  - Literal mode → observable byte-by-byte / pixel-equivalent parity, validated by golden files when the oracle runs.
  - Modernized mode → semantic contract (events, transitions, textual content, states), without byte-by-byte visual comparison.
