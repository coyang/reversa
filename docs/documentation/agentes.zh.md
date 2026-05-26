# 4 个视觉 agent

Documentation Team 由四个 agent 加上 orchestrator 组成。每个 agent 按固定顺序运行，可以通过 `/reversa-docs-<role>` 独立调用，并且仅在 `.reversa/documentation/` 内部写入。

---

## Pipeline

```
Reversa Docs (orchestrator)
        │
        ▼  vendor bundle (阶段 0)
        │
        ▼
Mapper → Analyst → Storyteller → Publisher
```

每个 agent 之间有人工审核暂停。默认模式是交互式的。添加 `--auto` 可跳过暂停。

---

## 1. Reversa Docs (orchestrator)

**命令：** `/reversa-docs`

检测哪些来源可用，运行三问题访谈（读者画像、深度、视觉风格），从 `soul.md`（或项目名称）计算确定性 seed，将所有内容持久化到 `.config.json` 中，并驱动四个专家。将遥测保存到 `.state.json`，在后续运行时提供六种重新生成选项。

**产出：** `.config.json`、`.state.json` 以及其他 agent 的编排。

---

## 2. Mapper（映射器）

**命令：** `/reversa-docs-mapper`

项目的空间结构。以 3D 形式渲染 Code City（Three.js，使用 `reversa-arquitetura-3d` skill），其中每栋建筑是一个模块，高度编码代码行数（LOC），颜色编码复杂度。还生成 2D 力导向模块地图（D3），以及在检测到拓扑时生成并排的遗留 vs 现代视图。

**产出：** `arquitetura.html`、`modulos.html`、`topologia.html`（如果适用）。中间 JSON 留在 `assets/data/` 中供 Analyst 复用。

---

## 3. Analyst（分析师）

**命令：** `/reversa-docs-analyst`

量化仪表盘。Highcharts treemap（每个模块的 LOC）、columns（每个模块的复杂度）、sankey（模块之间的依赖关系）、histogram（LOC 分布）。当 `.reversa/chronicle.md` 存在时，还渲染一个交互式的项目事件时间线。

复用 Mapper 的 JSON。在独立调用时，当这些 JSON 不存在时运行最小化的提取。

**产出：** `metricas.html`、`timeline.html`（当 chronicle 存在时）。

---

## 4. Storyteller（讲述者）

**命令：** `/reversa-docs-storyteller`

叙述和入门引导。三个产出物：交互式术语表（Concept Explainer，带客户端搜索）、可导航的幻灯片（6 到 10 张）以及每个功能在 *How a Feature Works* 布局中的详细页面。

不要求 Analyst 或 Mapper 作为硬性前置条件：幻灯片能适应已存在的任何页面。在只有 `soul.md` 的 greenfield 项目中，仍然产出术语表和最小化的 4 张幻灯片。

**产出：** `glossario.html`、`deck.html`、`features/<spec>.html`（每个 SDD spec 一个页面）。

---

## 5. Publisher（发布者）

**命令：** `/reversa-docs-publisher`

pipeline 的最后一步。将三位专家的作品集成为一个连贯的迷你站点，带有独特的 generative seal（通过 `reversa-selo-generativo` skill），追溯性地将 mini-seal 注入每个页面，自动发现其他 Reversa 核心 agent 留下的辅助 HTML（通过 `reversa-category` meta 标签），验证链接，并在声明成功之前运行真实的冒烟测试（启动 `http.server`，获取每个页面，grep 错误模式）。

负责 **vendor bundle**：基于 `references/vendor-pins.yaml` 将 Three.js、D3、Highcharts 和模块下载到 `assets/vendor/`，带 CDN 重试。这是使迷你站点能够通过 `file://` 和离线工作的关键。

**产出：** `index.html`（hero + seal + nav）、`assets/js/data.js`（注入 `window.RV_DATA`）、`assets/vendor/*`，以及 `.state.json` 中的最终遥测。

---

## 共享 skills

该团队附带五个共享 skills。它们不是独立的 agent，而是供四位专家消费的能力构建块。

| Skill | 使用者 | 用途 |
|-------|---------|---------|
| `reversa-arquitetura-3d` | Mapper | 在 Three.js 之上的 Code City 3D 渲染 |
| `reversa-especialista-d3` | Mapper | D3 力导向模块地图 |
| `reversa-highcharts-visualizer` | Analyst | Highcharts treemap、sankey、histogram 和 columns |
| `reversa-image-prompt-json` | Storyteller | 幻灯片可选的高级封面图 |
| `reversa-selo-generativo` | Publisher | 每个项目独特的 generative seal，源自确定性 seed |

---

## 手动运行

你很少需要单独调用某个 agent。`/reversa-docs` 会编排一切。但如果某个特定页面出了问题，或者你想重新生成某个部分：

```
/reversa-docs                    # 完整 pipeline（带访谈和 CONTINUAR）
/reversa-docs --auto             # 完整 pipeline，无暂停，默认配置
/reversa-docs-mapper             # 重新生成 arquitetura / modulos / topologia
/reversa-docs-analyst            # 重新生成 metricas / timeline
/reversa-docs-storyteller        # 重新生成 glossario / deck / features
/reversa-docs-publisher          # 重新生成 index + seal + nav，重新运行冒烟测试
```

当 `assets/vendor/` 为空时，每个独立 agent 都会在序言中运行 Publisher 的阶段 0（vendor bundle），因此单 agent 调用仍然能生成一个可工作的页面。
