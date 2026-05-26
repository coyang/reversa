# 安装

## 系统要求

- 你的机器上安装了 **Node.js 18+**

如果还没有安装 Node.js，请到 [nodejs.org](https://nodejs.org) 安装，然后再回到这里。

---

## 一个命令就够了

在你要分析的遗留项目的根目录下：

```bash
npx reversa install
```

安装器会自动完成以下所有步骤：

1. 检测环境中存在的 AI 引擎（Claude Code、Codex、Cursor、Gemini CLI、Windsurf）
2. 询问要安装哪些 agent **团队**。`Reversa Agents Core` 始终包含在内；`Migration Agents`、`Code Forward Agents` 和 `Pricing and Size Agents` 默认选中；`Translators N8N->Specs->Python` 默认不选。CLI 会将每个选中的团队展开为其包含的 agent
3. 收集项目名称、编程语言和偏好设置
4. 将 agent 复制到 `.agents/skills/` 和 `.claude/skills/`（针对 Claude Code）
5. 创建引擎入口文件（`CLAUDE.md`、`AGENTS.md` 等）
6. 创建 `.reversa/` 结构，包含状态、配置和计划
7. 生成 SHA-256 清单，用于将来的安全更新

就像 `npm install` 一样，不过是用于你的逆向工程 agent 团队。

---

## 项目中会被创建什么

```
legacy-project/
├── .reversa/               ← 分析状态、配置和上下文
├── .agents/skills/         ← 通用 agent（所有引擎）
├── .claude/skills/         ← Claude Code 的镜像
├── CLAUDE.md               ← Claude Code 的入口点（如检测到）
├── AGENTS.md               ← Codex 的入口点（如检测到）
└── _reversa_sdd/           ← spec 的生成位置（初始为空）
```

!!! success "你的文件完好无损"
    安装器**只创建新文件**。它永远不会修改或删除项目中任何已有的文件。

---

## 在开始之前备份

!!! warning "强烈建议：做好备份"
    尽管 Reversa 从不修改你的文件，但 AI agent 可能会犯错。在开始分析之前：

    1. 确保所有文件已在 Git 中提交
    2. 将仓库放在 GitHub、GitLab 或 Bitbucket 上
    3. 做一个本地文件夹副本作为额外的安全保障：`cp -r my-project my-project-backup`

    如果发生意外，`git restore .` 就能解决。

---

## 稍后添加其他引擎

如果你希望以后添加对其他引擎的支持（例如，你只安装了 Claude Code，现在也想支持 Codex）：

```bash
npx reversa add-engine
```

安装器会检测已有的内容，只添加缺少的部分。
