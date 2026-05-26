# Migration Brief Schema

`migration_brief.md` 是第一个产出物。它在任何 agent 运行之前捕获迁移标准。Migration Team 的六个 agent 都会消费它。

---

## 如何收集

`/reversa-migrate` 在首次执行时运行一次交互式访谈。在后续运行时，它会提供 **review / keep / recreate**（审核 / 保留 / 重建）选项。

---

## 问题

访谈至少涵盖以下内容：

1. **迁移目标。** 为什么存在？它发生或不发生对业务有什么影响。
2. **成功指标。** 你怎么知道它成功了？明确的数值或定性目标。
3. **约束条件。** 截止日期、预算、技术约束（例如必须本地部署、必须符合隐私法规）。
4. **已知风险。** 你已经能看到的潜在风险因素。
5. **利益相关者。** 谁决策、谁使用、谁受影响。
6. **目标技术栈。** 期望的语言、框架和基础设施。**必填项。**

brief **不询问范式**：那是 Paradigm Advisor 的职责。

brief **不询问 appetite**：它会在范式选择之后被推导出来。

---

## 最小示例

```yaml
---
schemaVersion: 1
generatedAt: 2026-05-02T14:30:00Z
reversa:
  version: "1.2.17"
kind: migration_brief
producedBy: orchestrator
hash: "sha256:..."
---

# Migration Brief

## Migration objective
降低基础设施成本和新开发者的入职时间。遗留的 PHP 5.6 已不再受支持，招聘资深 PHP 开发者的成本每年都在增加。

## Success metrics
- 月度基础设施成本至少降低 40%。
- 新开发者入职时间从 4 周降至 2 周。
- 关键端点的 p95 延迟低于 200ms。

## Constraints
- 截止日期：2026-12-31 之前上线。
- 预算：最高 5 万美元咨询费 + 内部工时。
- 合规：GDPR 强制要求。
- 停机时间不超过 4 小时，在周日窗口进行。

## Known risks
- 内部团队较小，两名全职开发者。
- 部分模块的遗留文档较浅。
- 计费流程有敏感的财税规则。

## Stakeholders
- CTO：最终决策。
- 产品团队：定义流程优先级。
- 财务团队：验证计费流程。
- 合规团队：验证 GDPR。

## Target stack
- Language: Node.js 20.
- Framework: Fastify.
- Infrastructure: AWS Lambda + RDS PostgreSQL + SQS.
```

---

## brief 会经历什么

每个 agent 在产出之前都会读取 brief 和 `paradigm_decision.md`。agent 的决策必须与 brief **一致**，否则必须明确标记冲突。

例如：如果 brief 说"6 个月内上线"，而遗留系统有 800 条业务规则，Strategist 很可能会排除 Big Bang，并推荐 Strangler Fig，同时缩小第一波的范围。
