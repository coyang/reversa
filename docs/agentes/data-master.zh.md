# Data Master（数据大师）

**命令：** `/reversa-data-master`
**阶段：** 任意阶段

---

## 🗄️ 地质学家

地质学家绘制地下的地图：没人看到但却支撑一切的层。表、关系、约束、触发器、存储过程。支撑应用的隐形基础。

---

## 功能说明

地质学家绘制地下的地图：没人看到但却支撑一切的层。表、关系、约束、触发器、存储过程。支撑应用的隐形基础。

Scout 对数据库进行表层扫描（仅列出文件）。Data Master 则进行完整、深入、正式的分析。

---

## 分析来源

Data Master 使用项目中任何可用的资源：

1. **DDL 文件：** 包含 `CREATE TABLE`、`ALTER TABLE` 的 `.sql` 文件
2. **迁移脚本：** Laravel、Rails、Flyway、Liquibase、Alembic、Prisma
3. **ORM 模型：** Eloquent、ActiveRecord、SQLAlchemy、Hibernate、TypeORM
4. **截图：** 来自 DBeaver、pgAdmin、MySQL Workbench 等工具
5. **直接连接：** 仅只读；绝不执行 `INSERT`、`UPDATE`、`DELETE`、`DROP`

---

## 文档化内容

### 表清单

列出所有表及其名称和推断的用途，按业务领域分组。

### 详细结构

每个表：列名、类型、大小、是否可空、默认值；主键和外键；索引；约束。

### 关系

所有关系及其基数（1:1、1:N、N:M）、连接表和多态关系。

### 数据库中的业务规则

触发器（条件、事件、动作）、存储过程和函数（参数、逻辑、返回值）、视图和物化视图、包含业务逻辑的检查约束。

### 完整 ERD

以 Mermaid 格式生成（`erDiagram`）。对于大型数据库，按领域生成部分 ERD 加上一个简化的全局 ERD。

---

## 产出文件

| 文件 | 内容 |
|------|------|
| `_reversa_sdd/database/erd.md` | Mermaid 格式的完整 ERD |
| `_reversa_sdd/database/data-dictionary.md` | 所有表和列 |
| `_reversa_sdd/database/relationships.md` | 详细关系 |
| `_reversa_sdd/database/business-rules.md` | 数据库中的业务规则 |
| `_reversa_sdd/database/procedures.md` | 存储过程和函数（如有） |

---

## 置信度等级

| 情况 | 标记 |
|------|------|
| 直接 DDL 或迁移脚本 | 🟢 已确认 |
| 从 ORM 或截图推断 | 🟡 推断 |
| 无法访问 | 🔴 缺口 |
