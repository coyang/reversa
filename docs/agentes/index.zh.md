# Agents (智能体)

Reversa 协调 **6个专业化团队** 的智能体。每个智能体专注于一件事并做到最好；每个团队围绕工作的一个阶段进行组织。

中央编排器（Reversa 本身）协调谁在何时、以何种顺序、何种节奏进入。但你也可以在任何需要时直接触发任意智能体。

---

## 6个团队

| 团队 | 职责 | 安装方式 |
|------|------|----------|
| **Reversa Agents Core** | 遗留系统的发现和编排：地图绘制、挖掘、解读和文档化。详见下方表格。 | 始终安装 |
| **Code New Project Agents** | 从一行创意到 SDD 规范的绿地项目流水线。参见 [Code New Project Agents](../newproject/index.md)。 | 预勾选 |
| **Code Forward Agents** | 从规范驱动正向交付：需求、计划、待办、审计、质量、编码。参见 [Code Forward Agents](../forward/index.md)。 | 预勾选 |
| **Migration Agents** | 将遗留系统规范转化为现代技术栈的重建计划。参见 [Migration](../migracao/index.md)。 | 预勾选 |
| **Pricing and Size Agents** | 在规范基础上估算工作量、规模及定价。参见 [Pricing](../pricing/index.md)。 | 预勾选 |
| **Documentation Team** | 将提取的知识渲染为自包含的 HTML 迷你站点。参见 [Documentation Team](../documentation/index.md)。 | 预勾选 |
| **Translators N8N->Specs->Python** | 将结构化工件（如 N8N 工作流）转化为规范的适配器。参见 [N8N Translator](n8n.md)。 | 未勾选 |

下表详细列出了组成 **Reversa Agents Core** 团队的智能体。

---

## 必需智能体

这些是主流水线的一部分。编排器按照正确的顺序运行它们。

| 智能体 | 阶段 | 类比 | 职责 |
|--------|------|------|------|
| [Reversa](reversa.md) | 编排 | 乐队指挥 | 协调所有智能体，保存检查点，引导用户 |
| [Scout](scout.md) | 侦察 | 房地产经纪人 | 绘制表面地图：文件夹、语言、框架、依赖、入口点 |
| [Archaeologist](arqueologo.md) | 挖掘 | 考古学家 | 深度逐模块分析：算法、流程、数据结构 |
| [Detective](detetive.md) | 解读 | 福尔摩斯 | 提取隐式业务规则、ADR、状态机、权限 |
| [Architect](arquiteto.md) | 解读 | 制图师 | 将一切综合为 C4 图、ERD 和集成地图 |
| [Writer](redator.md) | 生成 | 公证人 | 生成 SDD 规范、OpenAPI 和带有代码追溯性的用户故事 |

---

## 可选智能体

默认安装，但可随时独立触发。

| 智能体 | 类比 | 使用时机 |
|--------|------|----------|
| [Reviewer](revisor.md) | 规范审查员 | Writer 之后：严格审查规范并验证缺口 |
| [Visor](visor.md) | 法医插画师 | 当系统的截图可用时 |
| [Data Master](data-master.md) | 地质学家 | 当 DDL、迁移脚本或 ORM 模型可用时 |
| [Design System](design-system.md) | 造型师 | 当 CSS 文件、主题或界面截图可用时 |

---

## 翻译器（输入适配器）

当遗留的"代码"不是源代码，而是可视化工作流等结构化工件时使用。生成 SDD 规范并准备好状态，让主流水线接手。

| 智能体 | 类比 | 使用时机 |
|--------|------|----------|
| [N8N Translator](n8n.md) | 认证翻译官 | 当你有一个导出为 JSON 的 N8N 工作流，想要将其文档化为规范或移植到 Python 时 |

---

## 推荐顺序

```
/reversa → 自动编排一切

或者手动控制每一步：

Scout → Archaeologist（N 次会话） → Detective → Architect → Writer → Reviewer

任何阶段均可选：
Visor · Data Master · Design System
```
