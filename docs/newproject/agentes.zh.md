# Greenfield agents

Code New Project Agents 团队由五个 agent 组成。orchestrator（`/reversa-new`）按固定顺序驱动其他四个 agent。每个 agent 读取前一个 agent 的产出并添加自己的产出物。

---

## Pipeline

```
Reversa New (orchestrator)
        │
        ▼
Ideator → Researcher → Drafter → Spec SDD
```

每个 agent 之间有一个 `CONTINUAR` 检查点。orchestrator 从不自行推进。

---

## 1. Reversa New (orchestrator)

**命令：** `/reversa-new`

读取初始 brief（内联传递或交互式询问），保存 `_reversa_sdd/newproject-brief.md`，按固定顺序驱动四个功能 agent，并在每个阶段之后在 `state.json#newproject_progress` 中写入检查点。

检测重新执行：如果 pipeline 已经在进行中，询问是继续、重建还是从指定 agent 重新运行。

**产出：** `_reversa_sdd/newproject-brief.md` 和 `state.json#newproject_progress` 下的 orchestrator 状态。

---

## 2. Ideator（构思者）

**命令：** `/reversa-ideator`

结构化头脑风暴，包含六个发散性问题：根本问题、提供的价值、替代方案、原始受众、成功指标、危险假设。每次提出一个问题（当引擎不支持批处理时），等待回答后再继续，并且从不会将问题合并为单一的 multi-shot prompt。

**产出：** `_reversa_sdd/ideation.md`。

---

## 3. Researcher（研究者）

**命令：** `/reversa-researcher`

将 `ideation.md` 中的原始受众转化为一到三个结构化的人物画像（persona），包含旅程（入口、摩擦点、结果）。用户选择人物画像的数量；agent 仅基于受众描述的广度提出建议。

**产出：** `_reversa_sdd/personas.md`。

---

## 4. Drafter（起草者）

**命令：** `/reversa-drafter`

将构思和人物画像综合为一份完整的 PRD：问题、成功指标、范围、非目标、约束条件、风险、待解决问题。作为综合器而非访谈者运行：从两个来源中提取所有能提取的内容，并提出最多两个覆盖性问题来填补最关键的缺口。任何仍未定义的内容都会被标记为 `🟡 [UNDEFINED, validate with user]`。

**产出：** `_reversa_sdd/prd.md`。

---

## 5. Spec SDD

**命令：** `/reversa-spec-sdd`

将 PRD 分解为逻辑组件，为每个组件编写一份 SDD spec，附带自动质量评分（0 到 100）和缺口分析。方法论是 **Pragmatic RFC plus LLM-First**：结构类似于 RFC（Problem / Goals / Design / Edge Cases），但经过优化，可被人类和 AI agent 同等消费。

该 agent 是全局 `sdd-spec` skill 的一个 **vendored**（内嵌）版本：它原生存在于 Reversa 内部，将 `prd.md` 作为主要来源读取，写入 `_reversa_sdd/sdd/`，为每个 spec 标记 🟡（planned）印章，完成后将接力棒交给 `/reversa-forward`。

也可以独立使用：评估现有 spec，或从用户提供的任何输入生成单个 spec。

**产出：** `_reversa_sdd/sdd/<component>.md`（每个组件一个文件）。

---

## 手动运行

你很少需要单独调用某个 agent。`/reversa-new` 会编排一切。但如果某个 agent 失败了，或者你想重做某个阶段：

```
/reversa-new                    # 检测进行中的 pipeline，提供 Continue / Recreate / Re-run from 选项
/reversa-ideator                # 独立运行，读取 newproject-brief.md
/reversa-researcher             # 独立运行，读取 ideation.md
/reversa-drafter                # 独立运行，读取 ideation.md + personas.md
/reversa-spec-sdd               # 独立运行，读取 prd.md 或用户传入的任何来源
```

每个独立 agent 都会验证自身的前置条件，并在缺失必要产出物时以明确的提示信息中止。
