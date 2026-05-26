# Reconstructor（重构器）

**命令：** `/reversa-reconstructor`
**角色：** 独立智能体（不在发现流水线内）

---

## 🧱 自下而上的构建者

当规范已存在时，Reconstructor 可以一次一个任务地从头重建整个系统。它每一步只读取所需的内容，每次会话只执行一个任务，然后暂停，这样长时间的重建不会消耗超出必要的 token。

---

## 功能说明

Reconstructor 将 Reversa 规范转化为**可执行的重建计划**，然后按需自下而上地实现每个任务。

它运行在两种模式下：

1. **计划模式**（首次调用时）：读取少量文件，推断依赖树，生成包含完整任务列表的 `reconstruction-plan.md`。它按依赖深度排序：先做模式和核心实体，依赖树的叶子先于依赖者，API 层和用户流程最后。
2. **执行模式**（后续每次调用）：选取计划中下一个未勾选的任务，只读取该任务声明的所需文件，实现该任务，标记为已完成，然后停止。

如果存在已完成的 `migration/` 文件夹，Reconstructor 会询问是从**原始规范**（忠于遗留系统）还是从**迁移规范**（目标技术栈上的新系统）重建，并相应标记计划。

---

## 为什么自下而上

先做没有依赖的组件，然后是其上的一切。这避免了桩代码、脚手架和返工：每个层级都建立在已完成的基础上。

## 为什么每次会话一个任务

为了节省 token。每个任务只携带它需要的上下文。你可以随时暂停和恢复，无需重建上下文，任何智能体都可以接手下一个任务，而无需重新阅读整个项目。

---

## 读取的内容（计划模式）

- `.reversa/state.json`（项目元数据，如存在）
- `_reversa_sdd/gaps.md`（如可用）
- `_reversa_sdd/confidence-report.md`（如可用）
- `_reversa_sdd/architecture.md`
- `_reversa_sdd/dependencies.md`
- `_reversa_sdd/traceability/code-spec-matrix.md`（如可用）
- `_reversa_sdd/migration/handoff.md`（当迁移完成时）

单元级文件（`<unit>/requirements.md`、`design.md`、`tasks.md`）在计划模式期间不读取，只在执行相应任务时读取。

---

## 产出文件

| 文件 | 内容 |
|------|------|
| `_reversa_sdd/reconstruction-plan.md` | 完整的自下而上任务列表，每个任务包含 `Reads:` 和 `Done when:`，以及从 `gaps.md` 映射的预检提醒 |

在执行过程中，Reconstructor 将实际代码写入目标项目（当源为迁移时，根据 `paradigm_decision.md`/`target_architecture.md`）。每个已完成的任务在 `reconstruction-plan.md` 中被勾选。

---

## 何时使用

- 在 `/reversa` 完成后，你想根据原始规范从头重新实现遗留系统时。
- 在 `/reversa-migrate` 完成后，你想根据迁移规范将新系统具现化时。
- 作为恢复路径：你可以随时暂停，稍后恢复，而无需重新启动上下文。

---

## 连接方式

```
/reversa  →  规范 (_reversa_sdd/)
                  │
                  ▼
/reversa-reconstructor  →  reconstruction-plan.md（一次性）  →  代码，一次一个任务
```

它**独立于主流水线**：从不妨碍 `/reversa`、`/reversa-forward` 或 `/reversa-migrate`。它在你选择重建时单独调用。
