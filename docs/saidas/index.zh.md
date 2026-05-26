# 生成的输出物

Reversa 产出的所有内容都放在 `_reversa_sdd/` 文件夹中（或你在 `config.toml` 中配置的任何名称）。遗留项目永远不会被触碰。

生成的产出物集合取决于分析开始时选择的 **文档级别**：

| 图例 | 级别 |
|--------|-------|
| *(all)* | 所有 3 个级别都会生成 |
| *(complete+)* | 仅在 `complete` 和 `detailed` 级别生成 |
| *(detailed)* | 仅在 `detailed` 级别生成 |

---

## 完整结构

```
_reversa_sdd/
├── inventory.md              # 项目清单 — 所有级别
├── dependencies.md           # 依赖项及版本 — 所有级别
├── code-analysis.md          # 每个模块的技术分析 — 所有级别
├── data-dictionary.md        # 完整数据字典 — complete+
├── domain.md                 # 术语表和业务规则 — 所有级别
├── state-machines.md         # Mermaid 状态机 — complete+
├── permissions.md            # 权限矩阵 — complete+
├── architecture.md           # 架构概览 — 所有级别
├── c4-context.md             # C4 图：上下文 — 所有级别
├── c4-containers.md          # C4 图：容器 — complete+
├── c4-components.md          # C4 图：组件 — complete+
├── erd-complete.md           # 完整 ERD（Mermaid） — complete+
├── deployment.md             # 基础设施图 — 仅 detailed
├── confidence-report.md      # 置信度报告 🟢🟡🔴 — 所有级别
├── gaps.md                   # 未解决的缺口 — complete+
├── questions.md              # 人工验证问题 — 所有级别
├── sdd/                      # 每个组件的 Spec — 所有级别
│   └── [component].md
│
├── openapi/                  # API spec — complete+
│   └── [api].yaml
│
├── user-stories/             # 用户故事 — complete+
│   └── [flow].md
│
├── adrs/                     # 追溯式架构决策 — complete+
│   └── [number]-[title].md
│
├── flowcharts/               # Mermaid 流程图 — complete+
│   └── [module].md
│
├── ui/                       # 界面 spec（Visor）
│   ├── inventory.md
│   ├── flow.md
│   └── screens/
│       └── [screen].md
│
├── database/                 # 数据库 spec（Data Master）
│   ├── erd.md
│   ├── data-dictionary.md
│   ├── relationships.md
│   ├── business-rules.md
│   └── procedures.md
│
├── design-system/            # Design tokens（Design System）
│   ├── color-palette.md
│   ├── typography.md
│   ├── spacing.md
│   ├── tokens.md
│   └── design-system.md
│
└── traceability/
    ├── spec-impact-matrix.md # 哪个 spec 影响哪些 — complete+
    └── code-spec-matrix.md   # 代码文件到对应 spec 的映射 — complete+
```

---

## 可追溯性

两个文件将所有内容连接起来：

**`traceability/code-spec-matrix.md`：** 将每个代码文件映射到其对应的 spec，并标注覆盖级别。你可以知道哪些已被覆盖，哪些还没有。

**`traceability/spec-impact-matrix.md`：** 映射哪个组件影响哪些。在更改之前，你可以知道变更的影响范围。

---

## 什么不应该提交

建议的 `.gitignore` 配置，避免将 Reversa 输出物与代码一起进行版本管理（除非你希望这样做）：

```gitignore
# Reversa outputs（可选：如果希望对 spec 进行版本管理则移除）
_reversa_sdd/

# 个人 Reversa 配置（永远不要提交）
.reversa/config.user.toml
```

---

## 下一步

手头有 spec 了？请参阅 [从 spec 开发](../desenvolvendo-com-specs.md)，了解构建系统的推荐顺序。
