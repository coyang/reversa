# Architect（架构师）

**命令：** `/reversa-architect`
**阶段：** 第 3 阶段 - 解读

---

## 📐 制图师

制图师实地考察一个地区后制作正式地图：平面图、立面图、结构图。从未踏足过那里的人也能仅通过地图理解一切。

---

## 功能说明

Architect 踏入已被挖掘和解读的领域，制作正式地图。其理念是：从未接触过项目的人，仅通过查看 Architect 产出的成果就能理解完整的结构。

它与 Detective 在第 3 阶段并行工作。Detective 提取*为什么*（业务规则、决策），而 Architect 综合*怎么做*（结构、组件、集成）。

---

## 产出内容

### C4 图

Architect 生成 C4 模型的所有三个层次：

**上下文（第 1 层）：** 系统位于中心，周围是用户、与之集成的外部系统以及通信协议。

**容器（第 2 层）：** 应用、服务、数据库、队列和缓存，包含各自的技术以及它们之间的通信方式。

**组件（第 3 层）：** 对于最相关的容器，列出内部组件及其职责。

所有图均以 Mermaid 格式生成，可在任何 Markdown 中渲染。

### 完整 ERD

所有实体及其主要属性、带基数的关系（1:1、1:N、N:M）、主键和外键。采用 Mermaid 格式（`erDiagram`）。

### 外部集成

消费和生产的 REST/GraphQL API、webhook、事件、消息、协议和数据格式。

### 技术债务

重复代码、不一致的模式、严重过期的依赖以及关键模块中测试的缺失。

### 规范影响矩阵

显示哪些组件影响哪些组件的矩阵。用于在做出变更前了解影响的波及范围。

---

## 生成的文件

| 文件 | 内容 |
|------|------|
| `_reversa_sdd/architecture.md` | 架构总览 |
| `_reversa_sdd/c4-context.md` | C4 图：上下文 |
| `_reversa_sdd/c4-containers.md` | C4 图：容器 |
| `_reversa_sdd/c4-components.md` | C4 图：组件 |
| `_reversa_sdd/erd-complete.md` | Mermaid 格式的完整 ERD |
| `_reversa_sdd/traceability/spec-impact-matrix.md` | 影响矩阵 |
