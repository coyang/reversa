# Confirmation Keywords (Multilingual)

Every orchestrator in Reversa pauses between phases / agents and waits for an explicit user signal before continuing — **unless `autopilot` is set to `full`**, in which case the pause is skipped and the next step begins automatically. To avoid forcing users to type a specific foreign-language keyword, **all orchestrators MUST accept ANY of the following synonyms as equivalent**, regardless of `chat_language`.

## Accepted "continue" keywords

| Language    | Keyword(s) accepted                                |
|-------------|----------------------------------------------------|
| English     | `CONTINUE`, `continue`, `next`, `go`, `proceed`, `ok` |
| 简体中文     | `继续`, `下一步`, `好的`, `好`, `OK`, `ok`              |
| Português   | `CONTINUAR`, `continuar`, `próximo`, `prosseguir`  |
| Español     | `CONTINUAR`, `continuar`, `SIGUIENTE`, `siguiente`, `seguir` |

Matching is **case-insensitive** and ignores surrounding whitespace and punctuation. A bare confirmation (`y`, `yes`, `sim`, `sí`, `是`, `1`) also counts as "continue".

## Accepted "stop / pause" keywords

| Language    | Keyword(s)                                  |
|-------------|---------------------------------------------|
| English     | `STOP`, `stop`, `pause`, `wait`, `no`       |
| 简体中文     | `停止`, `暂停`, `等等`, `不`, `否`             |
| Português   | `PARAR`, `parar`, `pausar`, `espera`, `não` |
| Español     | `PARAR`, `parar`, `pausar`, `espera`, `no`  |

## Prompting the user

When you ask for confirmation, render the prompt in the **`chat_language`** from `.reversa/state.json`, and **show the local keyword first** to keep the UX natural. You do **not** need to list all four languages in the prompt — just the local one.

### Autopilot interaction

The `autopilot` field in `.reversa/state.json` (default: `full`) controls whether a confirmation prompt is shown at all:

| `autopilot` | When to show the prompt |
|---|---|
| `off` | Show after every file / step |
| `unit` | Show only at unit / module / agent boundaries |
| `full` | Do NOT show routine confirmation prompts. Only show prompts for hard pauses (clarifications, overwrites, low context budget). |

When `autopilot = full`, instead of asking `Type CONTINUE`, simply emit a one-line progress note and continue (e.g. `✅ device/design.md done → next: device/tasks.md`). Full rules in `references/autopilot-mode.md`.

Examples:

- `chat_language = zh-cn` →  `回复「继续」进入下一步，或「停止」暂停分析。`
- `chat_language = en-us` →  `Reply CONTINUE to proceed, or STOP to pause.`
- `chat_language = pt-br` →  `Responda CONTINUAR para seguir, ou PARAR para pausar.`
- `chat_language = es`    →  `Responde CONTINUAR para seguir, o PARAR para pausar.`

## Implementation contract

```
def is_continue(reply: str) -> bool:
    s = reply.strip().lower().rstrip('.!?,;:')
    return s in {
        "continue", "next", "go", "proceed", "ok",
        "继续", "下一步", "好的", "好",
        "continuar", "próximo", "proximo", "prosseguir",
        "siguiente", "seguir",
        "y", "yes", "sim", "sí", "si", "是", "1",
    }

def is_stop(reply: str) -> bool:
    s = reply.strip().lower().rstrip('.!?,;:')
    return s in {
        "stop", "pause", "wait", "no",
        "停止", "暂停", "等等", "不", "否",
        "parar", "pausar", "espera", "não", "nao",
        "n", "0",
    }
```

When neither matches, treat the reply as **free-form input** (likely an answer to a question, not a control word) and continue the conversation.
