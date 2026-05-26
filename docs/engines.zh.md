# 支持的引擎

Reversa 支持市场上主流的 AI 引擎。安装器会自动检测环境中存在哪些引擎，但你可以随时通过 `npx reversa add-engine` 添加更多。

---

## 兼容性

| 引擎 | 创建的文件 | Skills 路径 | 激活方式 |
|------|------------|-------------|----------|
| **Claude Code** ⭐ | `CLAUDE.md` | `.claude/skills/reversa-*/` 和 `.agents/skills/reversa-*/` | `/reversa` |
| **Codex** ⭐ | `AGENTS.md` | `.agents/skills/reversa-*/` | `reversa` |
| **Cursor** ⭐ | `.cursorrules` | `.agents/skills/reversa-*/` | `/reversa` |
| **Gemini CLI** | `GEMINI.md` | `.agents/skills/reversa-*/` | `/reversa` |
| **Windsurf** | `.windsurfrules` | `.agents/skills/reversa-*/` | `/reversa` |
| **Antigravity** | `AGENTS.md` | `.agents/skills/reversa-*/` | `/reversa` |
| **Kiro** | （无） | `.kiro/skills/reversa-*/` 和 `.agents/skills/reversa-*/` | `/reversa` |
| **Opencode** | `AGENTS.md` | `.agents/skills/reversa-*/` | `reversa` |
| **Cline** | `.clinerules` | `.agents/skills/reversa-*/` | `/reversa` |
| **Roo Code** | `.roorules` | `.agents/skills/reversa-*/` | `/reversa` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | `.agents/skills/reversa-*/` | `/reversa` |
| **Aider** | `CONVENTIONS.md` | `.agents/skills/reversa-*/` | `reversa` |
| **Amazon Q Developer** | `.amazonq/rules/reversa.md` | `.agents/skills/reversa-*/` | `/reversa` |

---

## Claude Code

测试最充分、支持最好的引擎。使用原生斜杠命令，激活方式直观。Reversa 同时在 `.claude/skills/` 和 `.agents/skills/` 中创建文件（以兼容将来可能添加的其他引擎）。

---

## Codex

完全兼容。由于 Codex 不使用斜杠命令，激活方式是直接使用 agent 名称：`reversa`、`reversa-scout` 等。项目根目录的 `AGENTS.md` 文件作为入口点。

---

## Cursor

通过 `.cursorrules` 兼容。Cursor 从此文件读取规则，agent 以 skills 的形式可用。

---

## Gemini CLI 和 Windsurf

完整支持。Agent 存放在 `.agents/skills/` 中，通过每个引擎的原生机制访问。

---

## Antigravity

Google 的 agentic 开发平台，于 2025 年 11 月发布。原生读取 `AGENTS.md`（与 Codex 使用相同的文件）。如果项目中已经安装了 Codex，已有的 `AGENTS.md` 会被复用，不会重复。CLI 命令：`agy`。

---

## Kiro

Amazon 的 agentic IDE。Kiro 原生在 `.kiro/skills/` 中发现 skills，不需要引导文档。安装器将 agent 放在 `.kiro/skills/`（同时也放在 `.agents/skills/` 以兼容其他引擎）。通过 `/reversa` 或从 skill 描述中自动发现来激活。

---

## Opencode

终端中的开源编码 agent（SST）。原生读取 `AGENTS.md`，采用与 Codex 相同的约定。CLI 命令：`opencode`。和 Codex 一样，通过 agent 名称激活：`reversa`。

---

## Cline 和 Roo Code

支持自定义规则的 VS Code 扩展，分别通过 `.clinerules` 和 `.roorules` 实现。模式与 Cursor 和 Windsurf 相同：在项目根目录有一个规则文件，指示 agent 在激活 `/reversa` 时做什么。

---

## GitHub Copilot

使用 `.github/copilot-instructions.md` 作为自定义指令文件，Copilot 在每个会话中自动读取。安装器在 `.github/` 目录内创建该文件（该目录可能已存在于项目中）。

---

## Aider

终端中的编码 agent。根目录的入口文件 `CONVENTIONS.md` 通过 `--read CONVENTIONS.md` 传递，或在 `.aider.conf.yml` 中配置。与 Codex 和 Opencode 一样，通过名称激活：`reversa`。

---

## Amazon Q Developer

AWS AI CLI。使用 `.amazonq/rules/` 中的规则来按项目指示 agent。安装器创建 `.amazonq/rules/reversa.md`，不影响你可能已经在该文件夹中的其他规则。

---

## 同一项目中多个引擎

你可以同时安装所有引擎。`.agents/skills/` 中的 agent 被所有引擎共享。安装器为每个引擎创建特定的入口文件，不会冲突。

如果你的团队成员各自使用不同的引擎，这完全正常：每个人使用自己引擎的入口文件，但所有 agent 都在同一个位置。
