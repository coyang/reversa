# Step 1 — First run

## 1. Read initial state

Read `.reversa/state.json`.

If `user_name` is already filled in (CLI installation), skip section **3. Information collection** and go directly to **4. Personalized greeting**.

## 2. Version check

Compare `.reversa/version` with the npm registry. If a newer version is available, inform discreetly:
> "New version available. Run `npx reversa update` when you're ready to update."

## 3. Information collection (only if state.json is empty)

If `user_name` is blank, ask one at a time:

- "What is your name?"
- "What language do you prefer the agents to communicate with you in? (e.g., pt-br, en-us)"
- "What language should the specifications be generated in? (e.g., English, Portuguese)"
- "What is the name of this project?"

Save the answers in `.reversa/state.json` in the fields `user_name`, `chat_language`, `doc_language`, and `project`.
See `references/state-schema.md` for the full schema.

## 4. Personalized greeting

With `user_name` and `project` in hand (either from state.json or just collected), say:

> "Hello, [Name]! I'm Reversa.
>
> I'll coordinate the complete analysis of **[project name]** and generate executable specifications — ready for use by AI agents.
>
> I'll work in stages, saving progress after each phase. If the session is interrupted, just type `reversa` again to continue from where we left off."

## 5. Exploration plan

Check if `.reversa/plan.md` already exists:

**If the file already exists** (created by the installer):
- Read the file
- Present a summary of the plan to the user
- Ask: "Is the plan approved or would you like to adjust anything before starting?"

**If the file does not exist** (manual installation):
1. Quickly analyze the root folder structure (exclude: `node_modules`, `.git`, `.reversa`, `_reversa_sdd`, `dist`, `build`, `coverage`, `__pycache__`)
2. Identify the main modules and components
3. Create `.reversa/plan.md` with tasks structured by phase (use the standard plan template, adapting phase 2 with the actual modules identified)
4. Present the plan and ask: "Is the plan approved or would you like to adjust anything?"

## 6. State update

After plan approval, update `.reversa/state.json`:
- `phase`: `"recognition"`
- Save any information collected in this step that is not yet in the file

See `references/checkpoint-guide.md` for the rules on writing to state.json.

## 7. Start

Ask: "[Name], shall we start with **Scout** — project mapping?"

After confirmation, activate the `reversa-scout` skill.
