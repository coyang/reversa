# Forward agents

Code Forward Agents 团队由十个 agent 组成。orchestrator（`/reversa-forward`）检测当前功能的物理阶段并建议下一个 skill。其余九个覆盖从自由格式想法到可运行代码的完整生命周期。

orchestrator 在 **两种场景** 下运行：在已填充 `_reversa_sdd/` 的遗留系统上演进，或者在还没有任何提取的 greenfield 项目上运行。两种情况下它都会准备好文件夹，并且绝不会阻塞 pipeline。

---

## Pipeline

```
Reversa Forward (orchestrator, 可选入口点)
        │
        ▼
Requirements → Clarify → Quality → Plan → To-Do → Audit → Coding
                (可选)   (可选)                  (可选)

Principles 和 Resume 在这条线性流程之外运行。
```

每个 agent 之间有一个 `CONTINUAR` 检查点。每个 skill 验证自身的前置条件，如果需要的前置产出物缺失则拒绝运行。`reversa-coding` 是最严格的：除非至少存在 `_reversa_sdd/architecture.md` 和 `_reversa_sdd/domain.md`，否则它会中止，以保持遗留代码到代码的桥梁稳固。

---

## 1. Reversa Forward (orchestrator)

**命令：** `/reversa-forward`

查看 `.reversa/state.json` 和 `_reversa_forward/<feature>/`，通过检查磁盘上的产出物（而非元数据）来检测物理阶段。建议下一个 skill，但从不自动执行：每次转换都以 `CONTINUAR` 请求结束。

检测 greenfield 场景（没有 `_reversa_sdd/`），创建 `/reversa` 本来会创建的文件夹，并让 pipeline 运行而不阻塞。

**产出：** 自身不产出任何内容。纯粹的路由。

---

## 2. Requirements

**命令：** `/reversa-requirements`

将自由格式的想法（"我希望用户能把发票导出为 PDF"）转化为完整的 `requirements.md`，锚定到 `_reversa_sdd/architecture.md`、`domain.md`、`state-machines.md` 和术语表。用 `[DOUBT]` 标记未确定点，列出缺口，并在 `.reversa/active-requirements.json` 中注册该功能。

检测进行中的功能：如果有另一个功能处于活动状态，询问用户是继续、并行运行（暂停前一个）还是放弃。从不自行决定。

**产出：** `requirements.md` 和 `active-requirements.json` 中的一条记录。

---

## 3. Clarify

**命令：** `/reversa-clarify`

生成最多五个针对性问题来清除 `[DOUBT]` 标记、模糊表述（"probably"、"maybe"）和明显缺口。问题是选择题或简答题，从不是开放式问题。答案被整合回 `requirements.md`，放在带日期的 `## Clarifications` 部分下。

**产出：** 对 `requirements.md` 的就地编辑。

---

## 4. Quality

**命令：** `/reversa-quality`

文档清晰度的只读审计者。它问的是：*这篇文章是否足够好，可以在不返工的情况下基于它做计划？* 分类：清晰度、完整性、术语、场景覆盖、边缘情况、行话、隐式方案、与 `principles.md` 的一致性。结论：Approved、Approved with reservations 或 Rejected。不检查实现测试。

**产出：** `audit/requirements-audit.md`。

---

## 5. Plan

**命令：** `/reversa-plan`

演进架构师。将需求转化为具体的技术方案，表示为**对遗留系统的增量变更**，从不是一次全面的重新架构。每个决策都带有置信度标记（🟢 强证据，🟡 部分或基于已接受的假设，🔴 弱证据）。与 `principles.md` 的冲突会被标记，但从不会被静默覆盖。

**产出：** `roadmap.md`、`investigation.md`、`data-delta.md`、`onboarding.md`、`interfaces/*`（每个受影响的外部契约一个文件）。

---

## 6. To-Do

**命令：** `/reversa-to-do`

将 roadmap 分解为跨越五个固定阶段的原子操作：Preparation（准备）、Tests（测试）、Core（核心）、Integration（集成）、Polish（打磨）。每个操作获得一个稳定的 ID（`T001`、`T002`……从不回收）、明确的依赖关系、目标文件、继承的置信度标记，以及当它可以与同级任务并行运行时标记为 `[//]`。

**产出：** `actions.md`。

---

## 7. Audit

**命令：** `/reversa-audit`

requirements、roadmap 和 actions 之间的只读交叉校验。发现按严重性报告（CRITICAL、HIGH、MEDIUM、LOW），沿四个轴分组：覆盖度、一致性、与遗留系统（`_reversa_sdd/domain.md`、`architecture.md`）的连贯性，以及 actions 图的合理性（无循环、并行任务不共享文件）。该 skill 从不编辑被分析的文档，即使用户要求也不行。

**产出：** `audit/cross-check.md`。

---

## 8. Coding

**命令：** `/reversa-coding`

执行器。按阶段遍历 `actions.md`，遵守 `[//]` 并行标记和依赖关系，仅在成功时将复选框从 `[ ]` 翻转为 `[X]`，并为每个操作在 `progress.jsonl` 中追加一行。完成（全部或部分）后，写入两条供下次 Discovery 运行的线索：

- `legacy-impact.md`：哪些遗留文件被触碰了。
- `regression-watch.md`：下次 Reversa 提取时必须保持为真的不变量。

**产出：** 源代码、`actions.md` 中更新的复选框、`progress.jsonl`、`legacy-impact.md`、`regression-watch.md`。

---

## 9. Principles

**命令：** `/reversa-principles`

管理 `.reversa/principles.md` 中的持久项目规则，与功能需求分离。原则很少变更（通常每月少于一次），使用罗马数字（I、II、III……）且从不回收，变更在历史部分中跟踪。当原则变更时，该 skill 会生成一份影响报告（`principles-impact-YYYYMMDD.md`），建议模板调整。由人来应用它们，skill 从不自动重写模板。

**产出：** `.reversa/principles.md` 和每次变更时的 `principles-impact-YYYYMMDD.md`。

---

## 10. Resume

**命令：** `/reversa-resume`

将当前功能与 `paused-features` 中的一个进行交换。检测每个暂停功能的物理阶段，发现任何孤儿条目（手动删除了文件夹的），并从不创建新功能。

**产出：** `active-requirements.json` 的就地交换。不涉及功能产出物。

---

## 手动运行

当你不记得当前功能停在哪里时，`/reversa-forward` 是推荐的入口点。但每个 skill 也可以独立激活：

```
/reversa-forward                 # 检测阶段并建议下一个 skill
/reversa-requirements <idea>     # 从自由格式想法开始一个新功能
/reversa-clarify                 # 解决 requirements.md 中的 [DOUBT] 标记
/reversa-quality                 # 审计文档清晰度（只读）
/reversa-plan                    # 从 requirements.md 生成对遗留系统的增量变更
/reversa-to-do                   # 从 roadmap.md 生成原子操作
/reversa-audit                   # 交叉校验三份文档（只读）
/reversa-coding                  # 执行 actions.md
/reversa-principles              # 管理持久规则
/reversa-resume                  # 与暂停的功能交换
```

`.reversa/hooks.yml` 中声明的 hooks（`before-<stage>` 和 `after-<stage>` 插槽）在每次转换时应用。
