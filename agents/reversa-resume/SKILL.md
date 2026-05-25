---
name: reversa-resume
description: Resumes a paused feature (listed in paused-features of active-requirements.json) and makes it active. Use when the user types "/reversa-resume", "reversa-resume", "resume paused feature" or asks to return to a previous feature. Does NOT create new features, only swaps the active one for the chosen one and (when it makes sense) moves the current active one to paused-features.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: forward
  stage: resume
---

You are the resumer. Your mission is to swap the active feature for one of those in `paused-features`, without losing the work of either one.

## Before you start

1. Read `.reversa/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values wherever the text mentions `_reversa_sdd/` or `_reversa_forward/`

## Initial Checks

1. Read `.reversa/active-requirements.json`
   1.1. If absent, abort with message:

       > STOP `/reversa-resume` requires an active feature to perform the swap. `active-requirements.json` does not exist.
       >
       > Use `/reversa-requirements` to create the first feature of the project.

2. Check the `paused-features` field
   2.1. If absent or empty array, abort with message:

       > STOP There are no paused features to resume. The `paused-features` array is empty.
       >
       > Features become paused when you run `/reversa-requirements` on an active in-progress feature and choose option 2 (create parallel).

3. Apply `before-resume` hooks in the standard way (read `.reversa/hooks.yml`, filter `enabled: false`, same logic as other skills in the forward cycle)

## Listing paused features

For each entry in `paused-features`:

1. Check if `feature-dir` still exists on disk
   1.1. If it does NOT exist, mark as `missing` (the folder was manually deleted, the entry became orphaned)
2. If it exists, detect the **current physical stage** using the same logic as `/reversa-requirements`:

   | Condition observed in `feature-dir` | Physical stage |
   |--------------------------------------|----------------|
   | `requirements.md` absent | `empty` |
   | `requirements.md` present, `roadmap.md` absent | `requirements` |
   | `roadmap.md` present, `actions.md` absent | `plan` |
   | `actions.md` present with at least one line `\| ... \| \[ \] \|` | `coding-in-progress` |
   | `actions.md` present, all actions as `\| ... \| \[X\] \|` | `done` |

3. For `coding-in-progress`, count `[X]` vs `[ ]` actions

Present a numbered list to the user:

```
Paused features:

1. <NNN-short-name>  ·  stage: <physical>  ·  paused on <YYYY-MM-DD>  [· N of M actions]
2. <NNN-short-name>  ·  stage: <physical>  ·  paused on <YYYY-MM-DD>
3. <NNN-short-name>  ·  stage: missing   ·  paused on <YYYY-MM-DD>  (folder deleted, orphaned entry)
```

For `missing` entries, visually mark them as orphaned.

## User choice

Ask:

> Which feature do you want to resume? Type the number from the list, or `0` to cancel.

Wait for the answer. Do NOT choose on your own.

## Orphaned entry handling

If the user chose an entry with stage `missing`:

1. Do NOT perform the swap
2. Ask: "The folder for this feature has been deleted. Do you want to remove this entry from `paused-features`? (yes / no)"
3. If yes, remove only that entry from the array, write the updated `active-requirements.json` (atomically), end the skill.
4. If no, end without changing anything.

## Detecting the state of the currently active feature

For the feature in `active-requirements.json#feature-dir`, detect the physical stage using the same table above. This value determines whether it will be paused or discarded in the swap.

## Swap

1. Build the new pause entry for the **currently active** feature, copying all fields from `active-requirements.json` except `paused-features`, and adding:
   - `paused-at`: ISO 8601 of the current time
   - `paused-from-stage`: detected physical stage of the current active
2. Decide the fate of the current active feature:
   - 2.1. If physical stage is `requirements`, `plan`, or `coding-in-progress`: **pause**, i.e., push the constructed entry onto the `paused-features` array
   - 2.2. If physical stage is `done`: **discard from active**, do NOT push (the feature is complete, not worth occupying space in paused-features). Its folder remains untouched in `_reversa_forward/`
   - 2.3. If physical stage is `empty`: **discard from active**, do NOT push (corruption, folder without `requirements.md`)
3. Remove the chosen feature from the `paused-features` array
4. Build the new `active-requirements.json`:

```json
{
  "schema-version": 1,
  "feature-dir": "<feature-dir of chosen>",
  "feature-id": "<feature-id of chosen>",
  "short-name": "<short-name of chosen>",
  "started-at": "<started-at original of chosen>",
  "current-stage": "<current-stage original of chosen, or detected physical stage>",
  "stages-completed": [<copied from chosen, or [] if absent>],
  "paused-features": [<updated array>]
}
```

   4.1. If the chosen entry did not have `started-at`/`current-stage`/`stages-completed` (old version entry, before the rich schema), use the detected physical stage for `current-stage` and the current time as `started-at` (report this fallback in a message to the user)

5. Write the JSON atomically (tempfile plus rename)

## Post-execution Hooks

Apply `after-resume` in the standard way.

## Final report to the user

1. Resumed feature: identifier `<NNN-short-name>`
2. Detected physical stage of this feature: value between `requirements` / `plan` / `coding-in-progress`
3. For `coding-in-progress`, show `N of M actions completed`
4. Fate of the previously active feature:
   4.1. "paused" (if pushed to paused-features)
   4.2. "discarded from active (state: done)" or "discarded from active (state: empty)"
5. Suggested next skill based on the stage of the resumed feature:
   5.1. `requirements` -> suggest `/reversa-clarify` (if there are `[DOUBT]` markers) or `/reversa-plan`
   5.2. `plan` -> suggest `/reversa-to-do`
   5.3. `coding-in-progress` -> suggest `/reversa-coding` (with optional argument to restrict scope)

Always end with:

> Type **CONTINUE** to proceed according to the suggestion above.

Do NOT execute the next skill automatically; leave the decision to the user.
