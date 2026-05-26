<!--
需求审计文档 body 模板
由 /reversa-quality 加载。

填写规则：
- 总计十到三十项。太少则浅薄，太多则冗余。
- 每项具有此报告内稳定的 Q-NNN ID。
- 允许的分类：Clarity（清晰度）、Completeness（完整性）、Consistency（一致性）、Coverage（覆盖率）、EdgeCases（边界情况）、Jargon（术语）、ImplicitSolution（隐式方案）、Principles（准则）。
- 未通过的项目增加一行 "> reason: ..." 和适用时的 "> suggestion: ..."。
- 此命令评估**编写质量**。不要包含实现测试类项目（"验证按钮是否工作"等）。
-->

# 需求审计

> 功能标识符：`<NNN>-<短名称>`
> 日期：`YYYY-MM-DD`
> 审计文档：`<功能目录>/requirements.md`

## 摘要

| 指标 | 值 |
|--------|-------|
| 总项数 | <NN> |
| 通过 | <NN> |
| 未通过 | <NN> |
| 结论 | Approved（通过）/ Approved with reservations（有条件通过）/ Rejected（驳回） |

## 各项分类

### Clarity（清晰度）

- [ ] Q-001 | Clarity | 需求中的每句话都有明确的主语、谓语和宾语
- [ ] Q-002 | Clarity | 没有以"也许"、"大概"或"如果可能"开头但没有数值限定的句子
- [ ] Q-003 | Clarity | 项目术语表中的术语在首次出现时已定义

### Completeness（完整性）

- [ ] Q-004 | Completeness | 所有必填模板章节均已填写内容，而非占位符
- [ ] Q-005 | Completeness | 每条功能需求都有可验证的验收标准
- [ ] Q-006 | Completeness | 存在正向和负向用例的 Gherkin 场景

### Consistency（一致性）

- [ ] Q-007 | Consistency | 关键领域术语在所有章节中拼写一致
- [ ] Q-008 | Consistency | 某章节引用的 ID 在定义该 ID 的章节中存在
- [ ] Q-009 | Consistency | 置信度（🟢 / 🟡 / 🔴）与所引用的 `_reversa_sdd/` 源文档一致

### Coverage（覆盖率）

- [ ] Q-010 | Coverage | 每条功能需求至少有一个 Gherkin 场景
- [ ] Q-011 | Coverage | 每条新增或变更的业务规则在适用时引用了 `_reversa_sdd/domain.md` 中的原始规则

### EdgeCases（边界情况）

- [ ] Q-012 | EdgeCases | 相关数值限制具有具体数值（而非"很多"、"很少"）
- [ ] Q-013 | EdgeCases | 已考虑空值、null 和初始状态
- [ ] Q-014 | EdgeCases | 适用时已考虑并发、重试和超时

### Jargon（术语）

- [ ] Q-015 | Jargon | 一个刚加入团队的新人无需术语表即可理解需求
- [ ] Q-016 | Jargon | 首字母缩略词在首次出现时已展开说明

### ImplicitSolution（隐式方案）

- [ ] Q-017 | ImplicitSolution | 需求描述的是"做什么"，而非"怎么做"
- [ ] Q-018 | ImplicitSolution | 文档中未出现库、框架或商业产品名称

### Principles（准则）

- [ ] Q-019 | Principles | 每条业务规则遵循 `.reversa/principles.md` 中的现行准则
- [ ] Q-020 | Principles | 与准则的冲突已明确记录，而非隐藏

## 未通过项目详情

<!--
对评估后标记为 [ ] 的每项，重复 ID 并添加原因和修改建议。
对于 [X] 项，此处不写任何内容。
-->

### Q-NNN

> reason: <客观原因，一至两句话>
> suggestion: <作者可以应用的简短修改建议>

## 结论

<!--
选择以下三种之一：
- Approved（通过）：零未通过。
- Approved with reservations（有条件通过）：最多三项未通过，且无 CRITICAL 项。
- Rejected（驳回）：超过三项未通过，或至少一项 CRITICAL。

CRITICAL 项：覆盖率缺失、违反准则、章节间内部矛盾。
-->

**Approved（通过）/ Approved with reservations（有条件通过）/ Rejected（驳回）**

## 变更历史

| 日期 | 变更 | 作者 |
|------|--------|--------|
| YYYY-MM-DD | 由 `/reversa-quality` 生成的审计报告 | reversa |
