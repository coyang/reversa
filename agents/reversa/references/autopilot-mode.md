# Autopilot Mode

Controls **how often agents pause and wait for user confirmation** during long generation runs (Writer producing dozens of spec files, Forward orchestrator chaining requirements → plan → tasks → coding, etc.).

Configured by the `autopilot` field in `.reversa/state.json` (and `[analysis].autopilot` in `.reversa/config.toml`).

---

## The three modes

| Value | Behavior | When to use |
|---|---|---|
| `off` | Pause after **every file** and after **every agent**. Agent emits `Type CONTINUE to proceed.` and stops. | Maximum control. First-time users who want to inspect each artifact before the next runs. |
| `unit` | Pause only **between units / modules** (e.g. after finishing `device/requirements.md` + `device/design.md` + `device/tasks.md`) and **between agents**. Files inside a unit are produced back-to-back without pausing. | Recommended sweet spot. Lets you batch-review per module while removing per-file friction. |
| `full` (default) | **Never pause for CONTINUE.** Run the entire planned sequence (all files, all units, all agents) until the natural end of the orchestrator's plan. Still pauses for **genuine information needs** (clarifying questions, ambiguous business rules, missing prerequisites). | Default mode. You trust the plan and want maximum throughput. Best for most runs; switch to `off` when you need step-by-step control. |

---

## Where each agent must check this

Every agent that today emits a `Type CONTINUE to proceed.` between artifacts MUST:

1. Read `autopilot` from `.reversa/state.json` at activation time (cache it for the session).
2. Apply the rule below **instead of** the previous unconditional "stop and wait".

### Decision matrix

| Boundary | `off`        | `unit`              | `full`              |
|---|---|---|---|
| After producing a single **file** within the same unit | ⏸ pause for CONTINUE | ▶ auto-continue | ▶ auto-continue |
| After producing the **last file of a unit** (e.g. `tasks.md` closing a module) | ⏸ pause | ⏸ pause | ▶ auto-continue |
| After an **agent** completes (e.g. Scout → Archaeologist handoff) | ⏸ pause | ⏸ pause | ▶ auto-continue |
| **Long-session preventive pause** (≥ 3 units without a break, context running long) | ⏸ pause | ⏸ pause | ⏸ pause (always honored — see "Hard pauses" below) |
| User explicitly typed a stop keyword (`STOP / 停止 / PARAR`) | ⏸ pause | ⏸ pause | ⏸ pause |
| Agent has a **genuine question** for the user (ambiguous rule, missing input, destructive operation about to happen) | ⏸ ask | ⏸ ask | ⏸ ask |
| About to overwrite an existing file (EC-05 collision) | ⏸ ask | ⏸ ask | ⏸ ask |
| Reached the **end of the orchestrator's plan** | ✅ report & stop | ✅ report & stop | ✅ report & stop |

---

## Hard pauses (NEVER skipped regardless of mode)

Even in `full` mode, the following are **non-negotiable**:

1. **Destructive or irreversible operations** — overwriting an existing user file, writing outside `.reversa/` or `<output_folder>/`, modifying `package.json`, etc.
2. **Information gap that blocks correctness** — a 🔴 business rule that only the user can resolve, missing precondition file, contradictory inputs.
3. **Engine context running out** — when token budget is low enough that quality may degrade, the agent must offer to checkpoint and resume in a new session.
4. **User typed a stop / pause keyword** — see `confirmation-keywords.md`. The match is case-insensitive and accepted at any time.
5. **At least once per ~10 minutes of wall-clock work** — even in `full` mode, emit a one-line progress summary so the user sees the run is alive (no need to wait for confirmation).

---

## Recommended user prompts per mode

When you would have emitted the standard `Type CONTINUE to proceed.` line, replace it with the appropriate variant based on `autopilot` and `chat_language`:

### `autopilot = off`
- `chat_language = en-us` → `✅ <file> completed. Next: <next>. Type CONTINUE to proceed.`
- `chat_language = zh-cn` → `✅ <file> 已完成。下一个：<next>。输入 「继续」 继续。`
- `chat_language = pt-br` → `✅ <file> concluído. Próximo: <next>. Digite CONTINUAR para prosseguir.`
- `chat_language = es`    → `✅ <file> completado. Siguiente: <next>. Escribe CONTINUAR para seguir.`

### `autopilot = unit` (file inside a unit)
- `en-us` → `✅ <file> completed. Auto-continuing to <next>...`
- `zh-cn` → `✅ <file> 已完成。自动继续 <next>……`
- `pt-br` → `✅ <file> concluído. Continuando automaticamente para <next>...`
- `es`    → `✅ <file> completado. Continuando automáticamente con <next>...`

### `autopilot = unit` (end of a unit, before next unit)
- `en-us` → `✅ Unit <X> complete. Next unit: <Y>. Type CONTINUE to proceed, or STOP to pause.`
- `zh-cn` → `✅ 单元 <X> 已完成。下一个单元：<Y>。输入 「继续」 进入下一单元，或 「停止」 暂停。`

### `autopilot = full`
- `en-us` → `✅ <file> done → <next>` (one line, no question)
- `zh-cn` → `✅ <file> 完成 → 下一个 <next>`
- Just continue immediately; do not ask anything unless one of the **hard pauses** above triggers.

---

## Implementation contract (pseudo-code)

```python
def should_pause_after(boundary: str, mode: str) -> bool:
    """boundary ∈ {file_in_unit, unit_end, agent_end, plan_end, hard}"""
    if boundary == "hard" or boundary == "plan_end":
        return True
    if mode == "off":
        return boundary in {"file_in_unit", "unit_end", "agent_end"}
    if mode == "unit":
        return boundary in {"unit_end", "agent_end"}
    if mode == "full":
        return False
    return True  # unknown mode → safest = pause

def emit_progress(file, next_file, mode, chat_language):
    if should_pause_after("file_in_unit", mode):
        prompt_user_to_continue(file, next_file, chat_language)
        wait_for_continue_keyword()
    else:
        emit_one_line_progress(file, next_file, chat_language)
```

---

## How the user changes mode mid-run

The user can switch modes at any pause point by editing `.reversa/state.json` (or `.reversa/config.user.toml`) and saving. The next time the agent re-reads state (at every pause / at start of every new file), it picks up the new value. No restart required.

The user can also say it conversationally:
- `chat_language = zh-cn`: 「切换到全自动模式」 / 「全自动」 / 「一口气跑完」
- `chat_language = en-us`: `switch to full autopilot` / `autopilot full` / `just run it all`
- The agent should: (1) update `.reversa/state.json.autopilot` to the new value, (2) confirm: `🚀 Autopilot set to FULL. Continuing without pausing until the plan finishes.`, (3) continue.

Conversely, `slow down` / 「慢点」 / `pausar` should switch back to `off` immediately, even mid-stream.

---

## Default policy

- New installs default to `full` (maximum throughput; the user chose to run Reversa, so let it run).
- Existing installs without the field set MUST be treated as `full`.
- Users who want step-by-step control can set `autopilot = "off"` during `reversa install` or in `.reversa/config.user.toml`.
- Hard pauses (overwrites, genuine clarifications, low context) are always honored regardless of mode.
