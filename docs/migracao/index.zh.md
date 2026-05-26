# Migration Team（迁移团队）

Migration Team 是 Discovery Team（探索团队）之后的下一步。Discovery 负责产出遗留系统的 spec，而 Migration 则将这些 spec 转化为针对现代技术栈的重建计划。

---

## 前置条件

你必须先运行 `/reversa`，并且确保 `_reversa_sdd/` 中已填充了遗留系统的 spec。如果没有，`/reversa-migrate` 会中止并给出明确的提示信息。

---

## 如何运行

```
/reversa-migrate
```

首次执行时会进行一次访谈（目标、成功指标、约束条件、目标技术栈），并生成 `_reversa_sdd/migration/migration_brief.md`。后续运行会复用该 brief。

---

## 执行流程

```
Brief（访谈）
   │
   ▼
[1] Paradigm Advisor    → 检测遗留系统的范式，标记差距，强制用户做出有意识的决策
   │
   ▼
[2] Curator             → 逐条决定哪些规则迁移、哪些丢弃
   │
   ▼
[3] Strategist          → 提出迁移策略（Strangler Fig、Big Bang、Parallel Run、Branch by Abstraction）
   │
   ▼
[4] Designer            → 草拟目标架构、领域模型、数据方案
   │
   ▼
[5] Screen Translator   → 将遗留界面转化为 spec（模式 + golden files）
   │
   ▼
[6] Inspector           → 定义行为等价性的验证标准
   │
   ▼
handoff.md              → 供 coding agent 使用的输入
```

每个 agent 之间有一个 **人工决策暂停点**。默认模式是交互式的。使用 `--auto` 可跳过暂停（不推荐在生产环境中使用）。

---

## 产出物存放位置

Migration Team 绝不会触碰遗留代码或 Discovery Team 的产出物。每次 `/reversa-migrate` 的输出都存放在 `_reversa_sdd/migration/` 中，即原始 spec 目录下的一个子文件夹。

```
<your-legacy-project>/
└── _reversa_sdd/                  ← Discovery Team 写入此处
    ├── inventory.md               (Scout)
    ├── dependencies.md            (Scout)
    ├── code-analysis.md           (Archaeologist)
    ├── data-dictionary.md         (Archaeologist)
    ├── domain.md                  (Detective)
    ├── state-machines.md          (Detective)
    ├── permissions.md             (Detective)
    ├── architecture.md            (Architect)
    ├── erd-complete.md            (Architect)
    │
    ├── <unit>/                    (Writer: 每个单元的功能文件夹，包含 requirements.md、design.md、tasks.md)
    ├── openapi/                   (Writer: API spec)
    ├── user-stories/              (Writer: 用户流程)
    ├── traceability/              (Writer + Architect: 追踪矩阵)
    ├── adrs/                      (Detective: 追溯式 ADR)
    ├── flowcharts/                (Archaeologist: 每个模块的 Mermaid 图)
    ├── ui/                        (Visor，如果运行过)
    ├── database/                  (Data Master，如果运行过)
    │
    └── migration/                 ← Migration Team 写入此处
        ├── migration_brief.md
        ├── paradigm_decision.md
        ├── target_business_rules.md
        ├── discard_log.md
        ├── migration_strategy.md
        ├── risk_register.md
        ├── cutover_plan.md
        ├── target_architecture.md
        ├── target_domain_model.md
        ├── target_data_model.md
        ├── data_migration_plan.md
        ├── parity_specs.md
        ├── parity_tests/
        │   └── *.feature
        ├── ambiguity_log.md
        ├── handoff.md
        ├── .state.json            (orchestrator 内部使用)
        └── .logs/
```

Migration Team 产出的文件：

| 文件 | 产出者 |
|---|---|
| `migration_brief.md` | 你（访谈） |
| `paradigm_decision.md` | Paradigm Advisor |
| `target_business_rules.md` + `discard_log.md` | Curator |
| `migration_strategy.md` + `risk_register.md` + `cutover_plan.md` | Strategist |
| `target_architecture.md` + `target_domain_model.md` + `target_data_model.md` + `data_migration_plan.md` | Designer |
| `screen_modernization_decision.md` + `target_screens.md` + `screen_deviation_log.md`（+ 若运行 oracle 则还包括 `screens/golden/*`） | Screen Translator |
| `parity_specs.md` + `parity_tests/*.feature` | Inspector |
| `handoff.md` | Orchestrator |

---

## 下一步

- [6 个 agent](agentes.md)：每个 agent 的职责、输入和输出。
- [范式转变](paradigma.md)：为什么范式很重要，以及 Paradigm Advisor 如何处理它。
- [迁移策略](estrategias.md)：4 种策略的目录。
- [Brief schema](brief.md)：`migration_brief.md` 的问题和格式。
