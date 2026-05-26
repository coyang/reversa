# Migration Team 的 6 个 agent

这些 agent 按固定顺序运行。每个 agent 读取前一个 agent 的产出并添加自己的产出物。`/reversa-migrate` 负责编排整个流程。

---

## Pipeline

```
Paradigm Advisor → Curator → Strategist → Designer → Screen Translator → Inspector
```

每个 agent 之间有人工审核暂停。默认模式是交互式的。

---

## 1. Paradigm Advisor（范式顾问）

**命令：** `/reversa-paradigm-advisor`（通常由 `/reversa-migrate` 调用）

检测遗留系统的范式，推断 brief 中声明的目标技术栈的自然范式，并标记差距。强制用户做出有意识的决策，因为更换语言很少仅仅是语法层面的变化，往往还意味着心智模型的根本转变。

**产出：** `paradigm_decision.md`（后续所有 agent 的必读文件）。

---

## 2. Curator（策展人）

**命令：** `/reversa-curator`

读取遗留系统的业务规则，并逐条决定：**MIGRATE**（迁移）、**DISCARD**（丢弃）或 **HUMAN DECISION**（人工决策）。考虑已选择的范式：那些属于遗留范式产物的规则（例如同步过程式系统中的手动锁），在事件驱动的目标范式下可以被丢弃。

**产出：** `target_business_rules.md` 和 `discard_log.md`。

---

## 3. Strategist（策略师）

**命令：** `/reversa-strategist`

评估可能的策略（Strangler Fig、Big Bang、Parallel Run、Branch by Abstraction），呈现明确的权衡，并推荐一个策略。最终决策由人做出。

考虑从 `paradigm_decision.md` 得出的 appetite（倾向）：保守倾向倾向于 Branch by Abstraction；变革倾向允许在小型系统上使用 Big Bang。

**产出：** `migration_strategy.md`、`risk_register.md`、`cutover_plan.md`。

---

## 4. Designer（设计师）

**命令：** `/reversa-designer`

草拟新系统的 spec：目标架构（含 Mermaid 图）、领域模型、数据模型和数据迁移方案。遵循已选择的范式（事件驱动需要显式的事件定义，带 DI 的 OO 需要接口等）。

不是简单地一对一分解：识别真正的限界上下文，并对分组和分离给出理由。

**产出：** `target_architecture.md`、`target_domain_model.md`、`target_data_model.md`、`data_migration_plan.md`。

---

## 5. Screen Translator（界面翻译器）

**命令：** `/reversa-screen-translator`（通常由 `/reversa-migrate` 调用，在 Designer 和 Inspector 之间执行）

将遗留界面转化为 coder 可以执行的 spec，而无需他们自行发明布局、颜色、文案或层次结构。分 **两个阶段** 运行：

- **阶段 1：** 检测源平台和目标平台，呈现三种翻译模式（literal（字面翻译）、modernized（现代化）、hybrid（混合））及其具体权衡，并强制用户做出决策。产出 `screen_modernization_decision.md`。
- **阶段 2：** 生成 `target_screens.md`（每个界面内嵌 YAML）和 `screen_deviation_log.md`。当遗留 oracle 运行时，还会在 `_reversa_sdd/screens/golden/` 下生成 golden files 以及 `manifest.yaml`，供 Inspector 进行视觉一致性测试。

对于没有 UI 的项目（批处理任务、纯 API、守护进程），输出 `mode: skipped`，Inspector 将跳过视觉一致性检查。

**产出：** `screen_modernization_decision.md`、`target_screens.md`、`screen_deviation_log.md`，可选的 `_reversa_sdd/screens/golden/*` + `manifest.yaml`。

---

## 6. Inspector（检查员）

**命令：** `/reversa-inspector`

定义如何证明新系统在关键方面与遗留系统行为等价。根据范式调整标准：同步 → 事件驱动的转变需要覆盖消息排序、幂等性和最终一致性。读取 Screen Translator 生成的 golden files（如果存在）来构建视觉一致性测试。

**产出：** `parity_specs.md` 和每个关键流程的 Gherkin `.feature` 文件。

---

## 手动运行

你几乎不需要单独调用某个 agent。`/reversa-migrate` 会编排一切。但如果某个 agent 失败了，或者你想从特定节点重新运行：

```
/reversa-migrate --resume                    # 从上次完成的 agent 继续
/reversa-migrate --regenerate=designer       # 删除 Designer + Inspector 的输出并重新生成
```
