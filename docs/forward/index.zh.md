# Code Forward Agents

**Code Forward Agents** 团队是从 spec 到可运行代码的桥梁。Discovery 回答的是*遗留系统做了什么？*；Forward 回答的是*接下来做什么，以及如何在不清除我们刚学到的东西的前提下进行构建？*。

该团队产出的每一份产出物都锚定在 Discovery 的输出（`_reversa_sdd/`）之上。当代码最终落地时，会留下两条供未来 Reversa 运行使用的线索：`legacy-impact.md`（遗留系统中哪些被更改了）和 `regression-watch.md`（下次提取时必须保持为真的不变量）。

在安装器中已预先勾选。

---

## 什么时候使用

你已经运行过 `/reversa`，并在 `_reversa_sdd/` 中有 spec。现在你想演进系统：一个新功能、一个扩展、一个需要在变成代码之前进行增量描述的修复。Forward 接收一句自由格式的话（"我希望用户能把发票导出为 PDF"），并将其沿着漏斗往下走，直到文件更改落实到磁盘上。

`/reversa-coding` 在没有至少 `_reversa_sdd/architecture.md` 和 `_reversa_sdd/domain.md` 的情况下拒绝运行。没有这些，遗留代码与代码之间的桥梁将是空洞的，Forward 将退化成一个通用的脚手架工具。

---

## Pipeline

```
/reversa-forward         (orchestrator，检测当前阶段并建议下一个 skill)
        │
        ▼
/reversa-requirements
        │     idea  →  requirements.md（带有 [DOUBT] 标记、缺口、术语表）
        ▼
/reversa-clarify           (可选)
        │     最多 5 个针对性问题  →  就地解决 [DOUBT]
        ▼
/reversa-quality         (可选，只读)
        │     审核文档清晰度  →  requirements-audit.md
        ▼
/reversa-plan
        │     requirements  →  roadmap.md、investigation.md、
        │                       data-delta.md、onboarding.md、interfaces/
        ▼
/reversa-to-do
        │     roadmap  →  actions.md（带有稳定 ID 的原子任务）
        ▼
/reversa-audit           (可选，只读)
        │     交叉校验三份文档  →  audit/cross-check.md
        ▼
/reversa-coding
        │     actions.md  →  代码，以及 legacy-impact.md
        │                          和 regression-watch.md
```

`/reversa-forward` 是整个循环的可选入口点：它查看当前状态并告诉你接下来该运行哪个 skill。当你记不清上次停在哪里时非常方便。
`/reversa-principles` 和 `/reversa-resume` 在这条线性流程之外运行。前者管理持久的项目规则；后者将当前功能与暂停在侧面的功能进行交换。

---

## 功能生命周期

功能由 `<NNN>-<short-name>` 标识（例如 `012-pdf-export`）。当前活动的功能在 `.reversa/active-requirements.json` 中跟踪；之前活动的功能可以放在 `paused-features` 队列中，并随时恢复。

```
.reversa/active-requirements.json
{
  "feature-dir": "_reversa_forward/012-pdf-export",
  "feature-id": "012",
  "short-name": "pdf-export",
  "started-at": "2026-05-08T14:22:00Z",
  "paused-features": [
    { "feature-dir": "_reversa_forward/011-multi-tenant", "paused-from-stage": "plan", ... }
  ]
}
```

功能的 **物理阶段** 通过检查磁盘上的产出物来检测，而不是通过元数据字段：

| 在 `feature-dir` 中观察到的内容                      | 物理阶段                |
|----------------------------------------------------|------------------------|
| `requirements.md` 缺失                               | `empty`                |
| `requirements.md` 存在，`roadmap.md` 缺失              | `requirements`         |
| `roadmap.md` 存在，`actions.md` 缺失                   | `plan`                 |
| `actions.md` 存在，且至少有一个 `[ ]` 复选框未勾选        | `coding-in-progress`   |
| `actions.md` 中所有 `[X]` 已勾选                       | `done`                 |

这意味着即使某个 skill 忘记更新其元数据，中断的会话也可以安全地恢复。

---

## Agents

| Agent | 阶段 | 写入 | 只读 |
|-------|-------|--------|------------|
| `reversa-forward` | orchestrator | （无，仅路由） | `state.json`、`active-requirements.json`、`_reversa_forward/` 中的功能产出物 |
| `reversa-requirements` | requirements | `requirements.md`、`active-requirements.json` |  |
| `reversa-clarify` | clarify | `requirements.md`（就地编辑） |  |
| `reversa-quality` | quality | `audit/requirements-audit.md` | `requirements.md` |
| `reversa-plan` | plan | `roadmap.md`、`investigation.md`、`data-delta.md`、`onboarding.md`、`interfaces/*` |  |
| `reversa-to-do` | to-do | `actions.md` |  |
| `reversa-audit` | audit | `audit/cross-check.md` | requirements + roadmap + actions |
| `reversa-coding` | coding | 源代码、`actions.md` 复选框、`progress.jsonl`、`legacy-impact.md`、`regression-watch.md` |  |
| `reversa-principles` | principles | `.reversa/principles.md`、`principles-impact-YYYYMMDD.md` |  |
| `reversa-resume` | resume | `active-requirements.json`（交换），不涉及功能产出物 |  |

### `reversa-requirements`
将自由格式的想法转化为完整的 `requirements.md`，通过 `_reversa_sdd/`（架构、领域、状态机、术语表）锚定到遗留系统。当检测到之前有一个正在进行的 feature 时，会询问用户是继续、并行运行（暂停前一个）还是放弃，从不自行决定。

### `reversa-clarify`
生成最多五个针对性问题来清除 `[DOUBT]` 标记、模糊表述（"probably"、"maybe"、"if possible"）和明显缺口。问题是选择题或简答题，从不是开放式问题。答案被整合回 `requirements.md`，放在带日期的 `## Clarifications` 部分下。

### `reversa-quality`
文档清晰度的只读审计者。它问的是：*这篇文章是否足够好，可以在不返工的情况下基于它做计划？* 分类涵盖：清晰度、完整性、术语、场景覆盖、边缘情况、行话、隐式方案和与 `principles.md` 的一致性。结论：Approved、Approved with reservations 或 Rejected。不检查实现测试。

### `reversa-plan`
演进架构师。将需求转化为具体的技术方案，表示为**对遗留系统的增量变更**，从不是一次全面的重新架构。每个决策都带有置信度标记（🟢 强证据，🟡 部分或基于已接受的假设，🔴 弱证据）。与 `principles.md` 的冲突会被标记，但从不会被静默覆盖。

### `reversa-to-do`
将 roadmap 分解为跨越五个固定阶段的原子操作：Preparation（准备）、Tests（测试）、Core（核心）、Integration（集成）、Polish（打磨）。每个操作获得一个稳定的 ID（`T001`、`T002`……从不回收）、明确的依赖关系、目标文件、继承的置信度标记，以及当它可以与同级任务并行运行时标记为 `[//]`。

### `reversa-audit`
requirements、roadmap 和 actions 之间的只读交叉校验。发现按严重性报告（CRITICAL、HIGH、MEDIUM、LOW），沿四个轴分组：覆盖度、一致性、与遗留系统（`_reversa_sdd/domain.md`、`architecture.md`）的连贯性，以及 actions 图的合理性（无循环、并行任务不共享文件）。该 skill 从不编辑被分析的文档，即使用户要求也不行。

### `reversa-coding`
执行器。按阶段遍历 `actions.md`，遵守 `[//]` 并行标记和依赖关系，仅在成功时将复选框从 `[ ]` 翻转为 `[X]`，并为每个操作在 `progress.jsonl` 中追加一行。完成（全部或部分）后，写入 `legacy-impact.md`（哪些遗留文件被触碰了）和 `regression-watch.md`（下次 Reversa 提取时必须保持的不变量）。

### `reversa-principles`
管理 `.reversa/principles.md` 中的持久项目规则，与功能需求分离。原则很少变更（通常每月少于一次），使用罗马数字（I、II、III……）且从不回收，变更在历史部分中跟踪。当原则变更时，该 skill 会生成一份影响报告（`principles-impact-YYYYMMDD.md`），建议模板调整。由人来应用它们，skill 从不自动重写模板。

### `reversa-resume`
将当前功能与 `paused-features` 中的一个进行交换。检测每个暂停功能的物理阶段，发现任何孤儿条目（手动删除了文件夹的），并从不创建新功能。

---

## 产出物存放位置

```
<your-legacy-project>/
├── .reversa/
│   ├── active-requirements.json     (活动功能 + 暂停队列)
│   ├── principles.md                (持久项目规则)
│   ├── principles-impact-*.md       (每次原则变更的影响报告)
│   └── hooks.yml                    (可选的 before/after hooks)
│
└── _reversa_forward/                (来自 .reversa/state.json 的 forward_folder)
    └── <NNN>-<short-name>/          (每个功能一个文件夹)
        ├── requirements.md
        ├── roadmap.md
        ├── investigation.md
        ├── data-delta.md
        ├── onboarding.md
        ├── interfaces/              (每个受影响的外部契约一个文件)
        ├── actions.md
        ├── progress.jsonl           (每个已执行操作一行)
        ├── legacy-impact.md
        ├── regression-watch.md
        └── audit/
            ├── requirements-audit.md   (reversa-quality)
            └── cross-check.md          (reversa-audit)
```

Code Forward Agents 从不在无人监督的情况下触碰遗留代码；这仅发生在 `/reversa-coding` 内部，即便如此，该 skill 也会留下上述两条线索，以便下次 Discovery 运行能够检测到任何偏差。

---

## Hooks

每个 skill 应用 `.reversa/hooks.yml` 中匹配的 hook 条目，分为两个插槽：`before-<stage>` 和 `after-<stage>`（例如 `before-plan`、`after-coding`）。标记为 `optional: true` 的 hook 显示为建议命令；`optional: false` 的 hook 会阻塞该 skill 直到被执行。`condition` 字段被记录但从不会被自动评估，该决策权属于用户。
