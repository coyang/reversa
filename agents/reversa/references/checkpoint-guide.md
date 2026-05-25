# Checkpoint Guide — .reversa/state.json

Reversa is the only agent that **writes** to state.json. All other agents only read.

## Absolute rules

1. **Never remove existing fields.** Only add or update.
2. **Always read the file before writing** — another agent may have updated `checkpoints`.
3. **Save after each completed phase**, not just at the end.
4. **If context overflow occurs**, save immediately before pausing.

## What to save at each phase

### When starting a phase
```json
{
  "phase": "reconhecimento"
}
```

### When an agent completes
```json
{
  "checkpoints": {
    "scout": {
      "completed_at": "2026-04-26T10:30:00Z",
      "files": [
        "_reversa_sdd/inventory.md",
        "_reversa_sdd/dependencies.md",
        ".reversa/context/surface.json"
      ]
    }
  }
}
```

### When an entire phase completes
```json
{
  "phase": "escavacao",
  "completed": ["reconhecimento"],
  "pending": ["escavacao", "interpretacao", "geracao", "revisao"]
}
```

### When marking a partial Archaeologist task
```json
{
  "checkpoints": {
    "archaeologist": {
      "modules_analyzed": ["auth", "orders"],
      "modules_pending": ["payments", "users"]
    }
  }
}
```

## Phase sequence

```
null → reconhecimento → escavacao → interpretacao → geracao → revisao
```

When moving between phases:
- Remove the completed phase from `pending` and add it to `completed`
- Update `phase` to the next phase

## Example state.json with analysis in progress

```json
{
  "version": "1.0.0",
  "project": "my-system",
  "user_name": "Ana",
  "chat_language": "pt-br",
  "doc_language": "English",
  "answer_mode": "chat",
  "output_folder": "_reversa_sdd",
  "phase": "escavacao",
  "completed": ["reconhecimento"],
  "pending": ["escavacao", "interpretacao", "geracao", "revisao"],
  "checkpoints": {
    "scout": {
      "completed_at": "2026-04-26T10:30:00Z",
      "files": [
        "_reversa_sdd/inventory.md",
        "_reversa_sdd/dependencies.md",
        ".reversa/context/surface.json"
      ]
    },
    "archaeologist": {
      "modules_analyzed": ["auth", "orders"],
      "modules_pending": ["payments", "users"]
    }
  },
  "engines": ["claude-code"],
  "agents": ["reversa", "reversa-scout", "reversa-archaeologist"],
  "created_files": []
}
```

## Context overflow pause message

If context is running low, save the current checkpoint and say:

> "[Name], I'll pause here to preserve context. Everything is saved in `.reversa/state.json`. Type `reversa` in a new session to continue from where we left off."
