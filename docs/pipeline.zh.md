# 分析流水线

Reversa 通过 5 个阶段将遗留系统转化为可执行的规格说明。每个阶段有特定的 agent，中央协调器统筹一切按正确的顺序进行。

---

## 概览

```
第 1 阶段       第 2 阶段      第 3 阶段            第 4 阶段      第 5 阶段
侦查            挖掘           解读                 生成           审查
Scout          Archaeologist  Detective            Writer         Reviewer
                              Architect
```

**独立 agent**，可在任何阶段运行：**Visor**、**Data Master**、**Design System**

---

## 第 1 阶段：侦查

**Agent：** Scout

Scout 对项目进行第一次巡视。就像房产中介第一次看一套房子：不打开抽屉，不阅读所有文件，只是绘制领地地图。

它产生的内容：

- 完整的项目清单（`inventory.md`）
- 带版本号的依赖列表（`dependencies.md`）
- 为后续 agent 准备的 JSON 结构化数据（`.reversa/context/surface.json`）

Scout 完成后，Reversa 使用 `surface.json` 来个性化第 2 阶段：计划不再是一个通用的"分析代码"任务，而是变成每个已识别模块一个任务。

这也是 Reversa 展示 Scout 摘要并询问**文档级别**（`doc_level`）的时候：基础（essential）、完整（complete）或详细（detailed）。这个选择决定每个 agent 在后续阶段生成哪些产物——参见[使用方法](uso.md#documentation-level)中的完整表格。

---

## 第 2 阶段：挖掘

**Agent：** Archaeologist

Archaeologist 逐模块地挖掘代码。耐心而精确地，它记录每一个产物：函数、算法、数据结构、控制流程。不做解读或评判。只是精确描述存在的东西。

**重要提示：** Archaeologist 有意地每个会话只处理一个模块。大型项目有许多模块，试图一次分析所有内容会烧尽上下文并降低分析质量。

它产生的内容：

- 综合技术分析（`code-analysis.md`）
- 数据字典（`data-dictionary.md`）
- 每个模块的 Mermaid 流程图（`flowcharts/[module].md`）
- 每个模块的结构化数据（`.reversa/context/modules.json`）

---

## 第 3 阶段：解读

**Agent：** Detective + Architect

在这一阶段，分析从描述性转向解读性。两个 agent 在此阶段工作。

**Detective** 是团队的福尔摩斯。审视 Archaeologist 记录的内容并提问：*"但为什么这是在这里？谁做出了这个决定？git 历史揭示了什么？"* 提取隐式的业务规则、回溯式 ADR、状态机和权限矩阵。

**Architect** 是制图师。将所有内容综合为形式化的架构文档：三个层级的 C4 图（Context、Containers、Components）、完整 ERD、集成地图和技术债务。

它们产生的内容：

- 领域和业务规则（`domain.md`）
- Mermaid 状态机图（`state-machines.md`）
- 权限矩阵（`permissions.md`）
- 回溯式 ADR（`adrs/`）
- C4 图（`c4-context.md`、`c4-containers.md`、`c4-components.md`）
- 完整 ERD（`erd-complete.md`）
- 架构概览（`architecture.md`）

---

## 第 4 阶段：生成

**Agent：** Writer

Writer 是团队的公证员。将之前阶段发现的所有内容转化为形式化契约：每个单元（模块、端点、用例、功能等，取决于流程早期选择的组织方式）一个文件夹，其中包含三个标准 SDD 文件，外加跨领域的全局内容，如 OpenAPI spec 和用户故事。

每条陈述都标注有[置信度等级](escala-confianca.md)：🟢 CONFIRMED（已确认）、🟡 INFERRED（推断）或 🔴 GAP（空白）。

Writer 不会一次性生成所有内容。它会构建一个覆盖所有单元的计划，提交给你批准，然后一次生成一个文件，等待确认后再继续。这样允许增量审查并防止上下文浪费。

它产生的内容：

- 每个单元一个文件夹，包含 `<unit>/requirements.md`、`<unit>/design.md`、`<unit>/tasks.md`（当文档级别要求时，还包括可选的额外文件）
- API spec（`openapi/[api].yaml`）
- 用户故事（`user-stories/[flow].md`）
- 遗留代码到单元的可追溯性矩阵（`traceability/code-spec-matrix.md`）

---

## 第 5 阶段：审查

**Agent：** Reviewer

Reviewer 试图打破 spec。发现内部矛盾、不同 spec 之间的冲突、标记为 🟢 但实际上只是推断的陈述、未指明说明的明显行为。

它还会收集只有你能解决的 🔴 空白，并以验证问题的形式提交。在你回答之后，它会更新 spec 并生成最终的置信度报告。

额外功能：如果 Codex 插件在会话中处于活动状态，Reviewer 可以在自己做分析之前请求独立的交叉审查。

它产生的内容：

- 验证问题（`questions.md`）
- 最终置信度报告（`confidence-report.md`）
- 未解决的空白（`gaps.md`）
- 在原地更新 spec，重新分类标记

---

## 独立 agent

这些 agent 不属于特定阶段，可以随时触发：

| Agent | 使用时机 |
|-------|----------|
| **Visor** | 当你有系统的截图可用时 |
| **Data Master** | 当 DDL、迁移文件或 ORM 模型可用时 |
| **Design System** | 当 CSS 文件、主题或界面截图可用时 |
