# Step 2 — Session resume

## 0. Check for ongoing migration

First of all, read `.reversa/state.json` just to resolve `output_folder` (default `_reversa_sdd`).

Check if `<output_folder>/migration/.state.json` exists. If it doesn't, skip this section and proceed to section 1.

If it exists, read the file and classify the migration state:

| Condition | State |
|-----------|-------|
| `pendingAgents.length > 0` or `currentAgent.agent` is not `null` | in progress |
| `currentAgent.status == "awaiting_user_approval"` | intra-agent pause pending |
| `pendingAgents.length == 0`, `currentAgent.agent == null`, and `<output_folder>/migration/handoff.md` exists | completed |

If the state is **completed**, skip this section (the migration has already finished, nothing to ask) and proceed to section 1.

If the state is **in progress** or **intra-agent pause pending**, present the question to the user before anything else:

> "[Name], I found an **ongoing migration** in `<output_folder>/migration/`.
>
> - Completed: <N> of 6 agents (<list of completedAgents>)
> - Pending: <list of pendingAgents>
> - Current state: <currentAgent.agent or "awaiting human approval">
>
> How would you like to proceed:
>
> 1. **Resume migration**: return to the Migration Team where it left off
> 2. **Resume Reversa flow**: continue discovery/forward, ignore migration for now
> 3. **Cancel**: end this session without changing anything
> 4. **Other**: describe what you'd prefer to do
>
> Use the engine's interactive menu mechanism (in Claude Code, `AskUserQuestion`); on engines without menu support, ask the user to type the number 1–4 or free text."

Wait for the response. Do NOT choose on your own.

- If **1**: end `/reversa` here with the final instruction:
  > "To resume the migration, type `/reversa-migrate`. It detects the saved state and offers resume options."

  Do NOT activate `reversa-migrate` automatically; let the user type it (Reversa's explicit handoff pattern).
- If **2**: proceed with section 1 of this step normally.
- If **3**: end without doing anything.
- If **4** (free text): interpret the user's intent and offer the best possible route, without inventing new flows. If the intent is ambiguous, ask again once before deciding.

## 1. Read state

Read `.reversa/state.json` and `.reversa/plan.md`.

## 2. Version check

Compare `.reversa/version` with the npm registry. If a newer version is available, inform discreetly:
> "New version available. Run `npx reversa update` when you're ready to update."

## 3. Greeting

Say: "[Name], welcome back to Reversa!"

## 4. Progress summary

Show:
- Completed phases (`completed` field from state.json)
- Current phase (`phase` field) with the last task recorded in `checkpoints`
- Upcoming phases (`pending` field)

Example:
> "Current progress:
> Reconnaissance completed
> Excavation in progress — modules `auth` and `orders` analyzed, `payments` and `users` pending
> Interpretation, Generation, Review"

## 5. Gap response mode

If `answer_mode` is `"file"`:
> "Remember: your answers to the questions must be filled in `_reversa_sdd/questions.md`. Let me know when you're done."

If `answer_mode` is `"chat"` (default):
> Continue normally — I'll ask the questions here in the chat.

## 6. Confirmation

Just ask: "Shall we continue from where we left off? (type CONTINUE to proceed)"

After confirmation, resume the next pending task in the plan (`.reversa/plan.md`).

**Do NOT offer `/clear` + `/reversa` at this point.** The user just resumed the session; asking them to clear and reopen now is redundant. The pause prompt between steps (described in `SKILL.md`, section "Preventive checkpoint between steps") only applies **after** an agent has completed work within this session, never during the resume greeting itself.

See `references/checkpoint-guide.md` for the rules on writing to state.json.
