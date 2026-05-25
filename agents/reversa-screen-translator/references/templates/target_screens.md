---
schemaVersion: 1
generatedAt: <ISO-8601>
reversa:
  version: "x.y.z"
kind: target_screens
producedBy: screen-translator
mode: literal | modernized | hybrid
sourcePlatform: <slug>
targetPlatform: <slug>
adapter: <adapters/source__target>
screenCount: <int>
hash: "sha256:<hash of body below front-matter>"
---

# Target Screens

> Executable specification of each screen of the new system, derived from the legacy according to the mode approved in `screen_modernization_decision.md`. Textual content preserved literally, unless explicit linguistic revision approval.
> Primary reading for the coder. Each section is a contract.

## Summary

- **Applied mode**: <literal | modernized | hybrid>
- **Screens generated**: <N>
- **Adapter**: <slug>
- **Tokens consumed**: see `_reversa_sdd/design-system/tokens.md` and `tokens-derived.md` when applicable
- **Golden files**: <N> in `_reversa_sdd/screens/golden/` (manifest in `golden/manifest.yaml`)
- **Deviations registered**: <N> in `screen_deviation_log.md`

> If the legacy has no UI (batch system / API / daemon), replace this section with:
> "No screens detected. Agent skipped in `skipped` mode. Next agent: Inspector."

---

## Screen: <canonical-name>

**Origin**: `<legacy-file>:<line-or-paragraph>`
**Applied mode**: literal | modernized
**Design-system components**: [<token1>, <token2>, ...]
**Interpolation points**: `{{var1}}`, `{{var2}}`
**Exit transitions**: [<next screen or event>]
**Critical screen?**: yes | no (consult `reversa-detective` when available)

### Specification

> The block below varies according to the source→target pair and mode. See `references/adapter-pairs.md` for the canonical format of each pair. Examples below.

#### Example: COBOL TUI → Go CLI/TUI (literal)

```yaml
spec.kind: ansi-byte-stream
spec.normalize:
  - trim_trailing_spaces: false
  - line_endings: "\n"
spec.lines:
  - bytes: "\x1b[96m╔══════════════════════════════════════════════════╗\x1b[0m\n"
  - bytes: "\x1b[96m║                \x1b[93m▓▓▓  BANK ATM  ▓▓▓\x1b[96m               ║\x1b[0m\n"
  - bytes: "\x1b[96m║                  \x1b[97m{{header_subtitle}}\x1b[96m                ║\x1b[0m\n"
    interpolations:
      header_subtitle:
        type: string
        max_width: 16
        source: literal "ATM Machine" | literal "System Access"
  - bytes: "\x1b[96m╚══════════════════════════════════════════════════╝\x1b[0m\n"
spec.input_prompts:
  - kind: accept-line
    prompt_bytes: "   \x1b[96m>>\x1b[97m Select an option: \x1b[0m"
    captures: option
    valid: ["0", "1", "2", "3", "4", "5"]
```

#### Example: Win32/Delphi VCL → Web SPA (modernized)

```yaml
spec.kind: component-tree
spec.states: [idle, loading, error, success]
spec.root:
  component: PageLayout
  variant: form
  children:
