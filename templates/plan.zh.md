# 探索计划 —— {{PROJECT}}

> 由 Reversa 于 {{DATE}} 创建
> 每完成一项任务请标记 ✅。
> 你可以在开始前编辑此计划：根据需要添加、移除或重新排列任务。

---

## 第一阶段：侦察 🔍

- [ ] **Scout（侦察兵）** — 映射文件夹结构和技术栈
- [ ] **Scout（侦察兵）** — 分析依赖关系和包管理器
- [ ] **Scout（侦察兵）** — 识别入口点、CI/CD 和配置

## 规范组织方式决策 🗂️

> 在 Scout（侦察兵）与 Archaeologist（考古学家）之间，Reversa 会询问你希望如何组织规范（按模块、用例、端点、混合、按功能或自定义）。选择将持久化保存在 `.reversa/config.toml` 的 `[specs]` 段落中，后续运行不再重复询问。如需重新显示菜单，请手动删除该段落。

## 第二阶段：挖掘 🏗️

> Scout（侦察兵）完成侦察后，Reversa 会在此章节填写实际模块。

- [ ] **Archaeologist（考古学家）** — 分析 Scout（侦察兵）识别出的模块

## 第三阶段：解读 🧠

- [ ] **Detective（侦探）** — Git 考古与追溯性 ADR
- [ ] **Detective（侦探）** — 隐式业务规则与状态机
- [ ] **Detective（侦探）** — 权限矩阵（RBAC/ACL）
- [ ] **Architect（架构师）** — C4 图表（上下文、容器、组件）
- [ ] **Architect（架构师）** — 完整 ERD 与外部集成
- [ ] **Architect（架构师）** — 规范影响矩阵

## 第四阶段：生成 📝

- [ ] **Writer（写手）** — 各组件 SDD 规范
- [ ] **Writer（写手）** — OpenAPI（如适用）
- [ ] **Writer（写手）** — 用户故事（如适用）
- [ ] **Writer（写手）** — 代码/规范矩阵

## 第五阶段：审核 ✅

- [ ] **Reviewer（审核员）** — 规范的交叉审核
- [ ] **Reviewer（审核员）** — 与用户解决缺口
- [ ] **Reviewer（审核员）** — 最终置信度报告

---

## 独立代理

> 当资源允许时运行这些代理——它们可以在任何阶段运行。

- [ ] **Visor（观察者）** — 通过截图进行界面分析
- [ ] **Data Master（数据大师）** — 完整数据库分析
- [ ] **Design System（设计系统）** — 设计令牌提取
- [ ] **Tracer（追踪者）** — 动态分析（需要可访问的系统）

---

## 下一步

当探索团队完成工作且 `_reversa_sdd/` 已填充内容后，你可以触发以下流程之一：

- `/reversa-migrate`：**迁移团队**的组织者（Paradigm Advisor → Curator → Strategist → Designer → Screen Translator → Inspector）。生成新系统的规范。输出在 `_reversa_sdd/migration/` 和 `_reversa_sdd/screens/`。
- `/reversa-reconstructor`：生成自底向上的计划，从遗留规范重新实现软件（每次会话一个任务）。
