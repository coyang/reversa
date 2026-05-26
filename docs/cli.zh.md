# CLI

Reversa 有一个简单的 CLI，用于管理项目中 agent 的安装和生命周期。所有命令都在项目根目录下使用 `npx reversa` 运行。

---

## 初始行为

当 CLI 启动时，在显示 Reversa ASCII logo 之前，必须先清空终端屏幕。Logo 应出现在终端的顶部，上方不能有任何之前的内容。

`by sandeco` 签名必须以白色出现在图案的最后一行，位于大字 `Reversa` 右侧的边距之后。它不能漂浮在 logo 高度的中间位置。

预期格式：

```text
  ______
  | ___ \
  | |_/ /_____   _____ _ __ ___  __ _
  |    // _ \ \ / / _ \ '__/ __|/ _` |
  | |\ \  __/\ V /  __/ |  \__ \ (_| |
  \_| \_\___| \_/ \___|_|  |___/\__,_|  by sandeco

  AI-Powered Reverse Engineering Framework
```

---

## 可用命令

### `install`

```bash
npx reversa install
```

在当前遗留项目中安装 Reversa。检测已存在的引擎，询问你的偏好，并创建所有必需的结构。

使用一次即可，在你想要分析的项目根目录下运行。

#### 安装菜单布局

安装器必须将菜单视为主要界面，而不是文本转储。问题必须编号，问题前要有一个空行，当显示选项时，问题和列表之间要有一个空行。

用户确认多选问题后，CLI 不能在连续的一行中打印所有选中的项目。这是禁止的，因为会形成一个冗长且难以阅读的段落。可以使用以下替代方案之一：

- 不渲染完整的选中项，直接继续下一个问题。
- 渲染一个简短的摘要，每个团队一行。

agent 菜单列出的是团队，而不是单个 agent。用户按团队选择；安装器将每个选中的团队展开为其包含的 agent：

1. `Reversa Agents Core`（以灰色显示，作为分隔符，始终安装）
2. `Migration Agents`
3. `Code Forward Agents`
4. `Pricing and Size Agents`
5. `Translators N8N->Specs->Python`（默认不选）

`Reversa Agents Core` 以灰色渲染，作为不可选择的分隔符，视觉效果上显示 `(*)`，就像一个已选中且禁用的选项：用户看到它，知道它已包含在内，光标会跳过它。它包含所有发现型 agent（Reversa、Scout、Soul Extractor、Archaeologist、Detective、Architect、Writer、Reviewer、Visor、Data Master、Design System、Agents Help、Reconstructor），因此之前的 "Discovery Add-ons" 组不再作为独立概念存在。尽管菜单隐藏了 agent 级别的细节，但最终安装摘要仍然按团队（Discovery、Migration、Code Forward、Translators、Pricing）细分计数。

---

### `status`

```bash
npx reversa status
```

显示当前分析状态：哪个阶段正在进行，哪些 agent 已经运行过，还需要完成什么。

用于在恢复会话前快速了解概况。

---

### `update`

```bash
npx reversa update
```

将 agent 更新到 Reversa 的最新版本。

这个命令很智能：它会检查每个文件的 SHA-256 清单，绝不会覆盖你自定义过的文件。如果你对任何 agent 做了调整，它们会保持不变。

---

### `add-agent`

```bash
npx reversa add-agent
```

向项目添加一个特定的 agent。如果你在初始安装时没有安装所有 agent，现在想要添加例如 Data Master 或 Design System，这个命令很有用。

---

### `add-engine`

```bash
npx reversa add-engine
```

为你安装时不存在的 AI 引擎添加支持。例如：你只为 Claude Code 安装了，现在想要添加 Codex。

---

### `uninstall`

```bash
npx reversa uninstall
```

从项目中移除 Reversa：删除安装时创建的文件（`.reversa/`、`.agents/skills/reversa-*/`、引擎入口文件）。

!!! info "你的文件完好无损"
    `uninstall` **只**移除 Reversa 创建的内容。不会触碰项目原有的任何文件。在 `_reversa_sdd/` 中生成的规格说明默认也会被保留。
