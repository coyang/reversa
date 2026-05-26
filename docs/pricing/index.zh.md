# Pricing and Size Agents（定价与规模评估 Agents）

**Pricing and Size Agents** 团队基于 Code Forward pipeline 产生的产出物，对每个功能的工作量、规模和价格进行估算。

在安装器中已预先勾选。

---

## Pipeline

```
/reversa-pricing-profile        (一次性设置：计费画像)
        │
        ▼
/reversa-pricing-size           (每个功能：结构化 T-shirt 规模评估)
        │
        ▼
/reversa-pricing-estimate       (每个功能：三种场景并排呈现)
```

`profile` 运行一次并可复用。`size` 和 `estimate` 在每个功能中运行，在 `/reversa-to-do` 之后。

---

## Agents

| Agent | 阶段 | 角色 |
|-------|-------|------|
| `reversa-pricing-profile` | profile | 引导式访谈（最多十个问题），产出用户的计费画像：国家、货币、标准化资历、时薪、项目加成、税务制度、计费模式、客户画像。 |
| `reversa-pricing-size` | size | 读取当前功能的需求、疑问、计划和任务，在 `size.json` 和 `size.md` 中产出确定性的结构化指标（基于任务数量加上风险调整的 T-shirt 规模评估）。 |
| `reversa-pricing-estimate` | estimate | 结合当前功能的 `profile.json` 和 `size.json`，产出三种教学性质的并排场景：Effort（工作量）、Value（价值）、Market Range（市场范围）。从不交付单一数字作为最终答案。 |

---

## 产出物存放位置

```
_reversa_sdd/_pricing/
├── profile.json               (一次性，来自 /reversa-pricing-profile)
├── profile.md
└── <feature>/
    ├── size.json              (每个功能，来自 /reversa-pricing-size)
    ├── size.md
    ├── estimate.json          (每个功能，来自 /reversa-pricing-estimate)
    └── estimate.md
```

Pricing and Size Agents 从不修改遗留代码、Discovery 产出物或 Forward 产出物。它们只读取这些内容，并在 `_pricing/` 内部写入。
