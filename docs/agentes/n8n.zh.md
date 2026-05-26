# N8N Translator（N8N 翻译器）

**命令：** `/reversa-n8n`
**阶段：** 翻译（输入适配器）

---

## 🔁 认证翻译官

认证翻译官接收一种语言的正式文档，生成另一种语言的版本，保留每项条款、期限和法律效力。N8N Translator 也是如此：它读取导出为 JSON 的工作流，生成捕获相同业务行为的 SDD 规范，随时准备用 Python 或任何其他语言重新实现。

---

## 功能说明

当遗留的"代码"不是源代码，而是导出为 JSON 的可视化 N8N 工作流时，N8N Translator 就是入口点。它遍历节点图，从语义上解读每一步（不仅仅是按节点类型），并生成三个独立于 N8N 描述系统的 SDD 工件。

规范生成后，该智能体准备 `.reversa/state.json` 和 `.reversa/plan.md`，以便常规的 Reversa 流水线（Scout、Archaeologist、Detective、Architect、Writer、Reviewer）可以在需要时接管并完善分析。

---

## 分析内容

- **工作流结构：** 触发器、节点图、分支（`if`、`switch`）、合并、循环（`splitInBatches`）、子工作流
- **每个节点：** 在业务上下文中的用途、输入、输出、转换、外部依赖
- **Function/Code 节点：** 读取嵌入的 JS 或 Python，用自然语言描述逻辑
- **凭证：** 按类型列出引用的凭证（`oAuth2Api`、`httpHeaderAuth` 等），不暴露值
- **外部集成：** API、数据库、SaaS 服务、webhook
- **Python 等价实现：** 为每个节点建议 Python 库和实现模式（参考 `references/node-catalog.md`）

---

## 输入

该智能体使用专用的输入文件夹：`n8n_json_workflows/`。该文件夹在首次运行时自动创建。将你的 N8N 工作流 JSON 导出文件放入其中。如果存在多个文件，智能体会询问要处理哪一个。

---

## 产出文件

| 文件 | 内容 |
|------|------|
| `_reversa_n8n/<slug>/workflow-overview.md` | 源分析：元数据、Mermaid 流程图、节点表、凭证、歧义 |
| `_reversa_n8n/<slug>/requirements.md` | SDD 需求：功能性（`RF-NN`）、非功能性（`RNF-NN`）、验收标准 |
| `_reversa_n8n/<slug>/design.md` | Python 实现指南：架构、组件、库、文件夹结构、错误处理、配置、测试 |
| `.reversa/state.json` | 主 Reversa 流水线的初始状态（带 `source: "n8n"` 和 `source_artifacts`） |
| `.reversa/plan.md` | 带有 `Phase 0: N8N origin` 部分标记翻译步骤的计划 |

---

## 何时使用

当你有一个 N8N 工作流并且想要：

- 将其文档化为 SDD 规范以供审查或审计
- 在 Python（或其他语言）中重新实现，而不将 N8N 作为运行时依赖
- 在应用完整的 Reversa 流水线之前迁移到自定义架构（FastAPI、worker、CLI）

```
/reversa-n8n
```

在该智能体完成后，运行 `/reversa` 以继续使用 Scout 和流水线的其余部分。
