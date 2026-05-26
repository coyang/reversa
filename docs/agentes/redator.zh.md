# Writer（写作者）

**命令：** `/reversa-writer`
**阶段：** 第 4 阶段 - 生成

---

## 📝 公证人

公证人将发现的内容转化为正式、精确、可追溯的合同。每条条款都有声明的置信度等级。这份文档是一份合同：AI 智能体可以据此重新实现整个系统。

---

## 功能说明

Writer 将前三个阶段发现的内容转化为正式的合同：精确、可追溯，并且详细到即使没有原始代码，AI 智能体也能忠实地重新实现功能。

规范不是供人类在安静的午后阅读的文档。它们是可操作的合同。

---

## 工作流程

Writer 从不会一次性生成所有内容。大型项目有众多组件，在一次响应中生成所有内容会消耗过多的上下文，并妨碍增量审查。流程如下：

### 1. 构建并展示计划

在生成任何文件之前，Writer 会读取之前所有阶段的工件以及 `config.toml` 的 `[specs]` 中保存的组织决策。然后构建它将生成的完整列表：

```
📋 生成计划：3 个单元，共 11 个文件

单元：
  [ ] 1. auth/requirements.md
  [ ] 2. auth/design.md
  [ ] 3. auth/tasks.md
  [ ] 4. orders/requirements.md
  [ ] 5. orders/design.md
  [ ] 6. orders/tasks.md
  [ ] 7. payments/requirements.md
  [ ] 8. payments/design.md
  [ ] 9. payments/tasks.md

全局：
  [ ] 10. openapi/api-v1.yaml
  [ ] 11. traceability/code-spec-matrix.md

输入 CONTINUE 开始。
```

在任何生成开始之前，你批准（或调整）计划。

### 2. 逐文件生成

对于每个条目：生成文件、保存、报告已完成内容和下一步内容，然后**停止**。你在确认"CONTINUE"后才会进入下一个。这允许你在继续之前审查每个规范。

### 3. 全局文件最后处理

所有单元文件生成完毕后，全局文件按顺序生成：`openapi/`、`user-stories/`，最后是将每个遗留文件与对应单元及其覆盖层级关联起来的 code-spec 矩阵。

---

## 输出布局：功能文件夹

每个单元成为 `<output_folder>/` 下的一个文件夹。"单元"取决于在组织步骤（在文档级别问题之后）中选择的 `granularity`：

| `granularity` | 一个单元对应... |
|---------------|----------------|
| `module` | 一个遗留模块 |
| `endpoint` | 一个 HTTP/RPC 端点或契约 |
| `use-case` | 一个行为用例 |
| `hybrid` | 顶层为模块，内部嵌套用例 |
| `feature` | Scout 列出的一个功能 |
| `custom` | 用户定义的文件夹 |

每个单元文件夹包含三个标准的 SDD 文件：`requirements.md`、`design.md`、`tasks.md`。可选文件（`contracts.md`、`flows.md`、`edge-cases.md`、`decisions.md`、`legacy-mapping.md`、`questions.md`）在文档级别和上下文需要时添加。

---

## 每个单元的标准文件

| 文件 | 内容 |
|------|------|
| `<unit>/requirements.md` | 单元做什么：业务规则、NFR、验收标准、MoSCoW |
| `<unit>/design.md` | 单元如何构建：接口、流程、依赖、设计决策 |
| `<unit>/tasks.md` | 可追溯到遗留代码的实现任务，包含完成标准和置信度 |

每个声明都标记为 🟢、🟡 或 🔴。无一例外。

---

## 跨切面全局文件

这些文件位于 `<output_folder>/` 的根目录下，在单元文件夹之外：

| 文件 | 内容 |
|------|------|
| `openapi/[api].yaml` | API 规范（如适用，仅 complete/detailed 级别） |
| `user-stories/[flow].md` | 用户故事（仅 complete/detailed 级别） |
| `traceability/code-spec-matrix.md` | 遗留文件到单元覆盖矩阵 |
