# Reversa 术语表（中英对照）

本术语表定义了 Reversa 框架在生成中文 spec 产物时，所有专有名词与技术术语的统一翻译规则。

## 翻译原则

1. **代码标识符**（变量名、类名、函数名、API 端点、路由路径）保持英文原文，不翻译
2. **文件路径**（如 `_reversa_sdd/architecture.md`）保持英文原文
3. **技术术语**按本表统一翻译，保持全文一致性
4. **本表标注"保留英文"的术语**在中文文档中不翻译，使用英文原文
5. **产品/框架名称**（Reversa, Scout, Archaeologist 等）保留英文，首字母大写
6. **置信度标记**使用统一的 emoji + 中文对照
7. **术语在上下文清晰时**可使用简称；首次出现时建议标注英文原文，例如"规格说明（spec）"

## 术语对照表

### Reversa 框架核心术语

| English | 中文 | 说明 |
|---------|------|------|
| Reversa | Reversa | 框架名称，保留英文 |
| spec | 规格说明 | 可简称 spec；指反向工程生成的规范性文档 |
| SDD | SDD | 规格驱动开发文档，保留英文缩写 |
| pipeline | 流水线 | 指逆向分析或正向开发的完整流程阶段序列 |
| agent | 代理 | 指框架中的 AI 代理角色 |
| skill | skill | 代理的技能描述文件（SKILL.md），保留英文 |
| orchestrator | 编排器 | 指 Reversa 主代理，负责编排整个分析流程 |
| state | 状态 | 指 `.reversa/state.json` 中持久化的运行状态 |
| checkpoint | 检查点 | 分析过程中的阶段性保存点 |
| phase | 阶段 | 指逆向分析的五个主要阶段 |
| plan | 计划 | 指 `.reversa/plan.md` 中的分析任务计划 |
| confidence scale | 置信度等级 | 用于标注信息可靠程度的三级体系 |
| reconnaissance | 侦察 | 第一分析阶段：项目表面映射 |
| excavation | 挖掘 | 第二分析阶段：代码深度分析 |
| interpretation | 解读 | 第三分析阶段：业务知识提炼与解读 |
| generation | 生成 | 第四分析阶段：生成可执行规格说明 |
| review | 审查 | 第五分析阶段：规格审查与质量把关 |
| output_folder | 输出文件夹 | 指 `_reversa_sdd/` 目录 |
| forward_folder | 正向文件夹 | 指 `_reversa_forward/` 目录 |
| re-extraction | 重新提取 | 对已完成正向开发的项目再次运行逆向分析 |
| doc_level | 文档级别 | 可选值：essential（基础）、complete（完整）、detailed（详细） |
| granularity | 粒度 | 指 spec 组织方式（按模块/用例/端点等） |
| context overflow | 上下文溢出 | 指 AI 模型上下文窗口接近耗尽的状态 |

### Reversa 代理名称

| English | 中文 | 说明 |
|---------|------|------|
| Scout | Scout | 侦察代理，保留英文，首字母大写 |
| Archaeologist | Archaeologist | 挖掘代理，保留英文，首字母大写 |
| Detective | Detective | 侦探代理，保留英文，首字母大写 |
| Architect | Architect | 架构师代理，保留英文，首字母大写 |
| Writer | Writer | 编写代理，保留英文，首字母大写 |
| Reviewer | Reviewer | 审查代理，保留英文，首字母大写 |
| Forward | Forward | 正向流水线编排器，保留英文 |
| Requirements | Requirements | 需求编写代理，保留英文 |
| Clarify | Clarify | 澄清代理，保留英文 |
| Plan | Plan | 计划代理，保留英文 |
| To-do | To-do | 任务分解代理，保留英文 |
| Audit | Audit | 审计代理，保留英文 |
| Coding | Coding | 编码代理，保留英文 |
| Quality | Quality | 质量代理，保留英文 |
| New | New | 新项目编排器，保留英文 |
| Ideator | Ideator | 创意生成代理，保留英文 |
| Researcher | Researcher | 研究代理，保留英文 |
| Drafter | Drafter | 草案编写代理，保留英文 |
| Spec SDD | Spec SDD | SDD 生成代理，保留英文 |
| Docs | Docs | 文档团队编排器，保留英文 |
| Doc Mapper | Doc Mapper | 文档映射代理，保留英文 |
| Doc Analyst | Doc Analyst | 文档分析代理，保留英文 |
| Doc Storyteller | Doc Storyteller | 文档叙事代理，保留英文 |
| Doc Publisher | Doc Publisher | 文档发布代理，保留英文 |
| Pricing Profile | Pricing Profile | 定价画像代理，保留英文 |
| Pricing Size | Pricing Size | 定价规模代理，保留英文 |
| Pricing Estimate | Pricing Estimate | 定价估算代理，保留英文 |
| Reviewer | Reviewer | 审查代理，保留英文 |

### 架构与技术术语

| English | 中文 | 说明 |
|---------|------|------|
| C4 diagram | C4 图 | C4 模型架构图（Context/Container/Component/Code），保留 C4 前缀 |
| ERD | ERD | 实体关系图，保留英文缩写 |
| ADR | ADR | 架构决策记录，保留英文缩写 |
| OpenAPI | OpenAPI | OpenAPI 规范，保留英文 |
| API | API | 应用程序编程接口，可译"接口" |
| REST | REST | REST 架构风格，保留英文 |
| GraphQL | GraphQL | GraphQL 查询语言，保留英文 |
| microservice | 微服务 | |
| monolith | 单体应用 | 单体架构 |
| clean architecture | 整洁架构 | 又称"清晰架构" |
| hexagonal architecture | 六边形架构 | 又称"端口与适配器架构" |
| layered architecture | 分层架构 | |
| event-driven architecture | 事件驱动架构 | |
| CRUD | CRUD | 增删改查，首现建议标注英文缩写 |
| dependency injection | 依赖注入 | |
| middleware | 中间件 | |
| webhook | Webhook | 网络钩子，保留英文或首次标注"网络钩子" |
| container | 容器 | 在 C4 模型中指服务/应用容器 |
| component | 组件 | 在 C4 模型中指容器内的内部组件 |
| endpoint | 端点 | API 端点 |
| schema | 模式/ schema | 数据模式；可保留英文 schema |
| contract | 契约 | 接口契约，指 API/服务之间的约定 |
| integration | 集成 | 系统间集成关系 |
| deployment | 部署 | |
| infrastructure | 基础设施 | |
| entity | 实体 | ERD 中的数据实体 |
| attribute | 属性 | 实体的属性字段 |
| cardinality | 基数 | 实体关系中的基数（1:1, 1:N, N:M） |
| traceability matrix | 追溯矩阵 | 需求/组件之间的追溯关系矩阵 |
| Mermaid | Mermaid | 图表渲染工具，保留英文 |
| UML | UML | 统一建模语言，保留英文缩写 |
| DTO | DTO | 数据传输对象，保留英文缩写 |
| ORM | ORM | 对象关系映射，保留英文缩写 |

### 需求相关术语

| English | 中文 | 说明 |
|---------|------|------|
| functional requirement | 功能需求 | 缩写 RF（Requisito Funcional） |
| non-functional requirement | 非功能需求 | 缩写 RNF（Requisito Não Funcional） |
| acceptance criterion | 验收标准 | |
| business rule | 业务规则 | |
| edge case | 边界情况 | 缩写 EC |
| gap | 空白 | 指南要由人来验证的信息缺失 |
| MoSCoW | MoSCoW 优先级 | 优先级分类法（Must/Should/Could/Won't），保留英文名 |
| persona | 用户画像 | |
| use case | 用例 | |
| user story | 用户故事 | |
| stakeholder | 利益相关者 | |
| feature | 功能特性 | |
| PRD | PRD | 产品需求文档，保留英文缩写 |
| requirements.md | requirements.md | 需求文档文件名，保留英文 |
| design.md | design.md | 设计文档文件名，保留英文 |
| tasks.md | tasks.md | 任务文档文件名，保留英文 |
| contracts.md | contracts.md | 契约文档文件名，保留英文 |
| flows.md | flows.md | 流程文档文件名，保留英文 |
| decisions.md | decisions.md | 决策记录文件名，保留英文 |

### Spec 文档章节标题

| English | 中文 | 说明 |
|---------|------|------|
| Executive Summary | 执行摘要 | |
| Context | 背景 / 上下文 | 视语境选择 |
| Goals | 目标 | |
| Non-Goals | 非目标 | 明确不属于本次范围的目标 |
| Users | 用户 | |
| Requirements | 需求 | |
| Functional Requirements | 功能需求 | |
| Non-Functional Requirements | 非功能需求 | |
| Happy Path | 主成功路径 | 标准成功场景 |
| Edge Cases | 边界情况 | |
| Dependencies | 依赖 | |
| Rollout | 发布计划 / 上线计划 | |
| Technical Debt | 技术债务 | |
| Architecture Overview | 架构概览 | |
| Data Dictionary | 数据字典 | |
| Data Flow | 数据流 | |
| Sequence Diagram | 时序图 | |
| State Machine | 状态机 | |
| Permissions Matrix | 权限矩阵 | |
| Integration Map | 集成地图 | |
| Test Plan | 测试计划 | |
| Migration Strategy | 迁移策略 | |
| Rollback Plan | 回滚计划 | |
| Monitoring | 监控 | |
| Glossary | 术语表 | |
| Appendix | 附录 | |
| Known Issues | 已知问题 | |
| Spec Impact Matrix | 规格影响矩阵 | |
| Questions | 待确认问题 | 指向需要人工验证的 🔴 空白项 |
| Code-Spec Matrix | 代码-规格追溯矩阵 | |

### 代码相关术语（保持英文）

| English | 中文 | 说明 |
|---------|------|------|
| file path | 文件路径 | 路径字符串保持英文 |
| variable name | 变量名 | 代码标识符保持英文 |
| class name | 类名 | 代码标识符保持英文 |
| function name | 函数名 | 代码标识符保持英文 |
| method name | 方法名 | 代码标识符保持英文 |
| API endpoint | API 端点 | URL 路径保持英文 |
| route | 路由 | 路由路径保持英文 |
| module | 模块 | 作为代码结构概念时保留英文，作为组织单位时可译"模块" |
| package | 包 | 代码包名保持英文 |
| namespace | 命名空间 | |
| dependency | 依赖 | 代码依赖包名称保持英文 |
| framework | 框架 | 框架名保持英文（如 Express, Spring, Django） |
| library | 库 | 库名保持英文 |
| repository | 仓库 / repository | 代码仓库；Git 语境中可保留英文 |
| directory | 目录 | 目录路径保持英文 |
| file extension | 文件扩展名 | 如 `.js`, `.py`, `.java` |
| commit | 提交 | Git 提交 ID 保持英文 |
| branch | 分支 | Git 分支名保持英文 |
| tag | 标签 | Git 标签名保持英文 |
| version | 版本 | 版本号（如 semver）保持原格式 |
| enum | 枚举 | |
| interface | 接口 | 代码 interface 定义保留英文 |
| type | 类型 | 类型名称保持英文 |
| config | 配置 | 配置文件名（如 `config.toml`）保持英文 |

### 产品与流程术语

| English | 中文 | 说明 |
|---------|------|------|
| artifact | 产物 | 指分析过程中生成的文档和文件 |
| deliverable | 交付物 | |
| handoff | 交接 | 代理之间的任务交接 |
| regression | 回归 | 指语义回归或功能回归 |
| regression-watch.md | regression-watch.md | 回归监控文件，文件名保留英文 |
| onboarding | 上手 / 接入 | |
| lifecycle | 生命周期 | |
| milestone | 里程碑 | |
| cross-review | 交叉审查 | |
| gap analysis | 空白分析 | 识别信息缺失并分类的过程 |
| playbook | 操作手册 | |
| retrospective | 回顾 | 项目回顾总结 |
| triage | 分类处理 | 对问题进行分类和优先级排序 |
| workflow | 工作流 | |
| state machine | 状态机 | |
| surface.json | surface.json | Scout 生成的表面分析文件，文件名保留英文 |
| state.json | state.json | 运行时状态文件，文件名保留英文 |
| config.toml | config.toml | 配置文件，文件名保留英文 |
| plan.md | plan.md | 分析计划文件，文件名保留英文 |

### 置信度标记

| English | 中文标记 | 说明 |
|---------|---------|------|
| 🟢 CONFIRMED | 🟢 已确认 | 直接从代码中提取的信息 |
| 🟡 INFERRED | 🟡 推断 | 基于模式推断，可能有误 |
| 🔴 GAP | 🔴 空白 | 需要人工验证的信息缺失 |
| Green | 绿色 | 回归检查中的通过状态 |
| Yellow | 黄色 | 回归检查中的存疑状态 |
| Red | 红色 | 回归检查中的未通过状态 |

### 正向开发流水线术语

| English | 中文 | 说明 |
|---------|------|------|
| forward cycle | 正向开发周期 | 从需求到编码的完整正向流程 |
| active feature | 活动特性 | 当前正在开发的功能特性 |
| regression-watch | 回归监控 | 对已编码特性的语义回归监控 |
| setup.json | setup.json | 特性设置文件，文件名保留英文 |
| actions.md | actions.md | 操作列表文件，文件名保留英文 |
| progress.jsonl | progress.jsonl | 进度日志文件，文件名保留英文 |
| legacy-impact.md | legacy-impact.md | 遗留影响分析文件，文件名保留英文 |
| blocking checkpoint | 阻塞检查点 | 需要用户确认才能继续的关键节点 |
| preventive checkpoint | 预防性检查点 | 防止上下文溢出的主动暂停点 |
| pause offer | 暂停提示 | 在代理完成工作后主动建议用户暂停 |

### 迁移相关术语

| English | 中文 | 说明 |
|---------|------|------|
| migration | 迁移 | 系统迁移 |
| paradigm | 范式 | 编程范式或架构范式 |
| strategy | 策略 | 迁移策略 |
| curator | 策展人 / Curator | 迁移团队代理，保留英文 |
| strategist | 策略师 / Strategist | 迁移策略代理，保留英文 |
| reconstructor | 重构者 / Reconstructor | 代码重构代理，保留英文 |
| paradigm advisor | 范式顾问 / Paradigm Advisor | 范式建议代理，保留英文 |
| screen translator | 界面转换器 / Screen Translator | 界面翻译代理，保留英文 |
| legacy code | 遗留代码 | |
| target architecture | 目标架构 | |
| incremental migration | 增量迁移 | |
| strangler fig | 绞杀者模式 | 逐步替换遗留系统的架构模式 |
| anti-corruption layer | 防腐层 | 新旧系统间的隔离层 |

### 通用技术术语

| English | 中文 | 说明 |
|---------|------|------|
| authentication | 认证 | |
| authorization | 授权 | |
| encryption | 加密 | |
| caching | 缓存 | |
| logging | 日志记录 | |
| monitoring | 监控 | |
| alerting | 告警 | |
| rate limiting | 速率限制 | |
| pagination | 分页 | |
| validation | 校验 | |
| serialization | 序列化 | |
| deserialization | 反序列化 | |
| callback | 回调 | |
| timeout | 超时 | |
| retry | 重试 | |
| circuit breaker | 熔断器 | |
| load balancer | 负载均衡器 | |
| message queue | 消息队列 | |
| event bus | 事件总线 | |
| service mesh | 服务网格 | |
| containerization | 容器化 | |
| orchestration | 编排 | |
| CI/CD | CI/CD | 持续集成/持续部署，保留英文缩写 |
| DevOps | DevOps | 保留英文 |
| SLA | SLA | 服务等级协议，保留英文缩写 |
| SLO | SLO | 服务等级目标，保留英文缩写 |
