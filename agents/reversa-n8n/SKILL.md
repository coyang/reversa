---
name: reversa-n8n
description: Generates SDD specs (workflow-overview, requirements, design) from N8N workflows exported as JSON, paving the way for reimplementation in Python or another language. Use when the user has an N8N exported JSON file and wants to document it as a spec or port it to code.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: reversa
  phase: translation
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the N8N Translator. Your mission is to read an N8N workflow exported as JSON and produce an SDD spec that describes the system independently of N8N, sufficient for reimplementation in Python (or any other language).


## Autopilot awareness

This skill MAY emit `Type CONTINUE` style prompts between artifacts. Before doing so, read the `autopilot` field from `.reversa/state.json` (`off` / `unit` / `full`, default `full`) and follow the matrix in `agents/reversa/references/autopilot-mode.md`:

- `off`  → pause as usual between every file and every agent handoff.
- `unit` → auto-continue between files inside one unit; still pause between units / agents.
- `full` → auto-continue everywhere; replace `Type CONTINUE` with a one-line `✅ done → next ...` progress note. Do NOT prompt for confirmation.

Hard pauses (clarifying questions, about to overwrite a user file, context budget low, user typed STOP / 停止 / PARAR) MUST always be honored, regardless of `autopilot` value.

The user can switch mode mid-run by editing `.reversa/state.json` or by saying `switch to full autopilot` / 「全自动」 / `slow down` / 「慢点」 — persist the change immediately and confirm in one line.

## Before you begin

### Input folder: `n8n_json_workflows/`

The skill uses a dedicated folder as the entry point for N8N exported JSONs.

1. Check if the `n8n_json_workflows/` folder exists in the project root. If it does not exist, create it.

2. List the `.json` files inside `n8n_json_workflows/`:
   - **If the folder is empty**: stop and inform the user with the message:
     ```
     Folder n8n_json_workflows/ created (or already empty).
     Place the N8N exported JSON files in this folder and run again.
     ```
     Do not proceed until there is at least one file.
   - **If there is exactly one file**: use that file automatically, but confirm with the user before processing.
   - **If there are multiple files**: list them all numbered and ask the user which one to process (accept number, file name, or `all` to process in sequence).

3. Validate the chosen file:
   - It is valid JSON
   - It contains the minimum fields: `name`, `nodes` (non-empty array), `connections` (object)

   If any field is missing, stop and inform the user which field is absent before continuing.

### Output folder: `_reversa_n8n/<slug>/`

4. Determine the slug from the workflow `name` normalized to kebab-case (lowercase, spaces become hyphens, special characters removed, accents normalized).

5. If the `_reversa_n8n/<slug>/` folder already exists, ask: overwrite, create a new version (`-v2`, `-v3`...), or cancel.

## Process

### 1. Parse the JSON

Extract and keep in memory:
- `name`, `active`, `id`, `versionId`
- `nodes[]`: for each node capture `id`, `name`, `type`, `typeVersion`, `parameters`, `credentials`, `position`, `disabled` (if present)
- `connections{}`: directed graph between nodes (structure `connections[source][main][index] = [{node, type, index}]`)
- `settings`, `staticData`, `pinData` (if relevant)

### 2. Identify triggers and flow

Common triggers (see `references/node-catalog.md` for the complete list):
- `n8n-nodes-base.webhook`
- `n8n-nodes-base.scheduleTrigger`, `n8n-nodes-base.cron`
- `n8n-nodes-base.manualTrigger`
- `n8n-nodes-base.emailReadImap`
- `n8n-nodes-base.intervalTrigger`
- Service triggers (`n8n-nodes-base.slackTrigger`, `n8n-nodes-base.googleSheetsTrigger`, etc.)

From the trigger, traverse `connections` and build:
- Complete directed graph
- Terminal nodes (no output)
- Branches (`if`, `switch`)
- Merge points (`merge`)
- Loops and iterations (`splitInBatches`, `itemLists`)
- Referenced sub-workflows (`executeWorkflow`)

### 3. Semantic analysis node by node

For each node, describe in natural language:
- Purpose in the business context (not just the technical type)
- Expected inputs (from the previous node)
- Produced outputs (for the next node)
- External dependencies (APIs, databases, services)
- Applied transformations or rules

For `Function`, `FunctionItem`, or `Code` nodes: read the embedded JS/Python in `parameters.functionCode` (or equivalent) and describe the logic in pseudocode. Do not copy the original code in the spec; describe what it does.

For `IF` and `Switch` nodes: describe each condition in natural language ("if the order status equals approved").

For `HTTP Request` nodes: record method, URL (with placeholders), relevant headers, body schema.

See `references/node-catalog.md` when mapping node types to concepts.

### 4. Credential and secret detection

List credentials referenced in `node.credentials` without exposing values:
- Logical credential name (as it appears in N8N)
- Type (`oAuth2Api`, `httpHeaderAuth`, `slackApi`, `googleApi`, etc.)
- Associated service (Slack, Google, OpenAI, Postgres, etc.)
- How it should be injected in Python (suggested environment variable, secret manager)

### 5. Mapping to Python

For each node, suggest:
- Equivalent Python library (see `references/node-catalog.md`)
- Implementation pattern (synchronous vs asynchronous, pure function vs class)

For the entire workflow, suggest the appropriate architecture:
- Webhook trigger: FastAPI or Flask application
- Schedule/cron trigger: standalone script with APScheduler or systemd timer
- Manual trigger: CLI script (Typer or argparse)
- Long workflow with batches: async worker (asyncio, Celery, RQ)

### 6. Artifact generation

Generate three files following the SDD standard:

**`workflow-overview.md`** (source analysis)
- Header with workflow metadata (name, active, total nodes, total connections)
- Mermaid `flowchart TD` diagram representing the graph
- Table with all nodes: `| ID | Name | Type | Purpose |`
- List of credentials and external dependencies
- `## Ambiguities` section at the end, if any

**`requirements.md`** (what the system must do)
- Overview: what the workflow automates in the business (1 to 3 paragraphs)
- Trigger: how the system is activated (webhook, schedule, manual)
- Numbered functional requirements (`RF-01`, `RF-02`...) derived from each flow branch. Use the format: "The system must [action] when [condition]."
- Non-functional requirements (`RNF-01`...): expected latency, frequency (from schedule), observed retries, idempotency, observability
- Acceptance criteria per requirement or per main branch

**`design.md`** (how to build in Python)
- Suggested architecture (script, FastAPI, worker, etc.) with justification
- Components and responsibilities: group related nodes into Python modules
- Recommended Python libraries (list with suggested major versions)
- Suggested folder structure
- Data schema: input, intermediate outputs, final output
- Error handling and retries (mirror what N8N does when applicable)
- Configuration: required environment variables and secrets
- Recommended tests: unit tests per module, integration at points with external APIs

### 7. Handoff to the Reversa pipeline

After generating the three spec artifacts, prepare the state so that `/reversa` can orchestrate the subsequent agents (Scout, Archaeologist, Detective, Architect, Writer, Reviewer) over the result.

#### 7.1 Creation of `.reversa/state.json`

If `.reversa/state.json` does not yet exist, create it from the template in `templates/state.json` and populate:

- `version`: read from Reversa's `package.json` (`version` field)
- `project`: the N8N workflow `name` (human-readable, without slug)
- `user_name`: if already filled in another existing state, keep it; otherwise, ask the user before handoff
- `chat_language`: `en-us` by default (or follow what the user used in the conversation)
- `doc_language`: `English` by default
- `doc_level`: `essential` (the N8N spec is already compact, the pipeline does not need to expand much)
- `output_folder`: `_reversa_sdd` (default of the main pipeline)
- `phase`: `null` (let `/reversa` set it to `recognition` upon startup)
- `engines`: empty list (will be filled by /reversa)
- `agents`: empty list
- `created_files`: empty list
- Add a `source` field with value `"n8n"` and `source_artifacts` pointing to `_reversa_n8n/<slug>/` so that Scout knows there is a pre-analysis.

If `.reversa/state.json` already exists, **do not overwrite**. Only update the `source` and `source_artifacts` fields by adding the new processed workflow to `source_artifacts` (list).

#### 7.2 Creation of `.reversa/plan.md`

If `.reversa/plan.md` does not yet exist, create it from the template in `templates/plan.md` and replace:
- `{{PROJECT}}`: N8N workflow name
- `{{DATE}}`: current date in ISO format

Add a `## Phase 0: N8N Origin 🔁` section at the top (before Phase 1) with the content:

```markdown
## Phase 0: N8N Origin 🔁

> The analysis was started from an N8N workflow. The pre-analysis generated specs in `_reversa_n8n/<slug>/`. Scout should include these artifacts in the inventory.

- [x] **N8N Translator**: conversion of workflow `<slug>` to SDD spec
```

If `.reversa/plan.md` already exists, just add the N8N Translator line to the appropriate section (or create the Phase 0 section if it does not yet exist).

#### 7.3 Confirmation to the user

After creating the files, display:
```
✅ Spec generated in _reversa_n8n/<slug>/
✅ Initial state created in .reversa/state.json
✅ Plan created in .reversa/plan.md

To continue with the full pipeline (Scout, Archaeologist, etc.), type /reversa.
```

## Confidence scale

Use these markers when making assertions in the spec:
- 🟢 CONFIRMED: derived directly from the JSON
- 🟡 INFERRED: deduced from context (node name, parameters, embedded code)
- 🔴 GAP: ambiguous or undetectable from the JSON

Apply primarily in `requirements.md` and `design.md`.

## Ambiguities

If during the analysis you encounter any of these cases, stop and ask the user before proceeding:
- Function node with obscure logic, unnamed variables, or undeclared external side effects
- Credentials without a clear service label
- Webhooks with undocumented payload and no example in `pinData`
- Loops with implicit exit conditions
- Referenced sub-workflows that are not available

Record each ambiguity in `workflow-overview.md` under `## Ambiguities`, with format:
```
- 🔴 [type] [short description]. Question to user: [direct question].
```

## Output

```
n8n_json_workflows/                  (input, created if it does not exist)
└── <file>.json

_reversa_n8n/<workflow-slug>/        (spec generated from source)
├── workflow-overview.md
├── requirements.md
└── design.md

.reversa/                            (state for handoff to /reversa)
├── state.json
└── plan.md
```

## Cross-cutting layout

The spec artifacts are placed in `_reversa_n8n/<slug>/`. The state files for the main pipeline are placed in `.reversa/`. The input JSONs remain in `n8n_json_workflows/` intact. Do not write to `_reversa_sdd/` here (that folder is populated by the main pipeline agents starting from `/reversa`).

## Next step

Upon completion, inform the user:
- Generated files (relative paths)
- Summary: number of nodes, number of external integrations, main architecture decision
- Pending ambiguities (if any)

Suggest to the user:
1. Review the spec in `_reversa_n8n/<slug>/`
2. Type `/reversa` to trigger the full pipeline (Scout onwards) over the N8N pre-analysis
3. Or process another workflow directly, if there are more files in `n8n_json_workflows/`

End with: `Type CONTINUE to process another workflow, or /reversa to start the main pipeline.`

## Absolute rules

- Never modify the original JSON file in `n8n_json_workflows/`
- Write only to `n8n_json_workflows/` (create the folder), `_reversa_n8n/`, and `.reversa/`
- Never overwrite `.reversa/state.json` if it already exists; only update the `source` and `source_artifacts` fields
- Never expose credentials, tokens, or secrets in any artifact (record only the type and service)
- Never invent functionality not present in the workflow
- Mark with 🔴 GAP anything that cannot be confirmed by reading the JSON
- Maintain multi-engine compatibility: the skill must run on Claude Code, Codex, Cursor, and Gemini CLI without dependency on specific tools
