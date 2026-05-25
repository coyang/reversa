# `handoff.md` Checklist

Before closing the pipeline, the orchestrator validates that `handoff.md` fulfills all items.

## Mandatory checklist

- [ ] `paradigm_decision.md` appears as the **first item** in the "Required reading" section and in the "Recommended reading order".
- [ ] `topology_decision.md` appears as the **second item** in the "Required reading" section.
- [ ] `screen_modernization_decision.md` appears as the **third item** when there is UI; in legacy without UI (Screen Translator skipped), the entry is omitted with an explicit note "Screen Translator skipped, legacy without UI".
- [ ] List of produced artifacts is complete and reflects the actual `_reversa_sdd/migration/` and `_reversa_sdd/screens/`.
- [ ] Pending deviations in `screen_deviation_log.md` appear as blockers; approved deviations are reflected in `parity_specs.md section Exceptions`.
- [ ] Items REFERRED TO CODING from `ambiguity_log.md` appear in a dedicated section of `handoff.md`.
- [ ] Blockers listed or line "no blockers, proceed".
- [ ] Next steps for the coding agent are specific and actionable (not generic).
- [ ] In `--auto`: auto-decided items listed explicitly.
- [ ] Style consistent with the installed engine (adapted format, e.g.: compatible front-matter).

## Minimum structure

1. Required reading banner for `paradigm_decision.md`, `topology_decision.md` and (if there is UI) `screen_modernization_decision.md`.
2. Recommended reading order.
3. Artifact list.
4. Blockers.
5. Next steps for the coding agent.
6. Auto-decided items (only if `--auto`).
7. Final notes.

## Strong signaling to the coding agent

The first sentence of `handoff.md` must convey immediate clarity. Suggested pattern:

> "New system to be built in paradigm <X>, topology <Y>, screens in mode <Z>. Before any line of code, read `paradigm_decision.md`, `topology_decision.md` and `screen_modernization_decision.md`."

In legacy without UI (Screen Translator skipped), replace the screens portion with: "screens: none (system without UI)".
