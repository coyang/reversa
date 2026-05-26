# Code New Project Agents

Code New Project Agents 团队是 Discovery Team 的 greenfield（全新项目）对应团队。Discovery 回答的是*现有遗留系统做了什么？*，而 New Project Team 回答的是*我们应该从零开始构建什么，以及用哪些 spec 来证明它？*。

Pipeline 从一句话想法一路走到一整套 SDD spec，准备进入 Code Forward Agents 循环。

在安装器中已预先勾选。

---

## 什么时候使用

你有一个想法但还没有代码。可能是一句话（"我希望用户能把发票导出为 PDF"），也可能是一段话。你想在打开 IDE 之前把产品想清楚：验证问题、绘制用户画像、撰写 PRD，然后将 PRD 分解为 AI agent 可以实现的 SDD spec。

使用以下命令激活：

```
/reversa-new
```

orchestrator 收集 brief，按固定顺序驱动四个功能 agent，在每个 agent 之间保存检查点，并在推进之前请求 `CONTINUAR`。如果会话中断，只需再次输入 `/reversa-new`：它会读取 `state.json#newproject_progress` 并精确地从停止的地方恢复。

---

## Pipeline

```
/reversa-new              (orchestrator)
       │
       ▼
/reversa-ideator          → _reversa_sdd/ideation.md
       │
       ▼ CONTINUAR
/reversa-researcher       → _reversa_sdd/personas.md
       │
       ▼ CONTINUAR
/reversa-drafter          → _reversa_sdd/prd.md
       │
       ▼ CONTINUAR
/reversa-spec-sdd         → _reversa_sdd/sdd/<component>.md
       │
       ▼
handoff: 建议使用 /reversa-forward
```

Spec SDD agent 是全局 `sdd-spec` skill 的一个 **vendored**（内嵌）版本，经过适配以在 Reversa 内部运行：它读取 `prd.md`，写入 `_reversa_sdd/sdd/` 内部，为每个产出物标记 🟡（planned）印章，并在最后将接力棒交给 Forward pipeline。

---

## 产出物存放位置

该团队仅在 `_reversa_sdd/`（Discovery 使用的同一文件夹）内部写入。Greenfield spec 与遗留 spec 并存而不冲突，因为文件名是互不相同的。

```
<your-project>/
└── _reversa_sdd/
    ├── newproject-brief.md      (orchestrator)
    ├── ideation.md              (Ideator)
    ├── personas.md              (Researcher)
    ├── prd.md                   (Drafter)
    └── sdd/
        └── <component>.md       (Spec SDD)
```

orchestrator 状态存放在 `.reversa/state.json` 的 `newproject_progress` 键下，包含 `stage`、`started_at`、`last_checkpoint_at`、`completed_stages` 和截断的 `brief`。

---

## 重新执行

当 pipeline 已经在进行中，而你再次输入 `/reversa-new` 时，orchestrator 检测到已保存的 `stage` 并提供四个选项：

1. **从中断处继续**（推荐）
2. **从头重建**（覆盖产出物，需要明确确认）
3. **从指定 agent 重新运行**（包含四个 agent 的子菜单）
4. **取消**

orchestrator 从不自行决定：每次覆盖都需要明确的 `sim` 确认。

---

## 下一步

- [Greenfield agents](agentes.md)：每个 agent 的职责、输入和输出。
- [Code Forward Agents](../forward/index.md)：Spec SDD 完成后的自然下一步。
