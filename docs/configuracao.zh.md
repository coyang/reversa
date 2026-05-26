# 配置

Reversa 将所有配置和分析状态存储在项目根目录下的 `.reversa/` 文件夹中。你可以随时打开和编辑这些文件。

---

## `.reversa/` 文件夹结构

```
.reversa/
├── state.json          ← 会话间的分析状态
├── config.toml         ← 项目配置
├── config.user.toml    ← 你的个人偏好（不要提交）
├── plan.md             ← 探索计划（可以编辑）
├── version             ← 已安装的 Reversa 版本
├── context/
│   ├── surface.json    ← Scout 生成的数据
│   └── modules.json    ← Archaeologist 生成的数据
└── _config/
    ├── manifest.yaml           ← 安装元数据
    └── files-manifest.json     ← SHA-256 哈希值，用于安全更新
```

---

## `config.toml`：项目配置

在安装时创建。定义与团队共享的设置：

```toml
[project]
name = "my-project"
language = "en"

[agents]
installed = ["reversa", "scout", "archaeologist", "detective", "architect", "writer", "reviewer"]

[output]
folder = "_reversa_sdd"

[engines]
active = ["claude-code"]
```

如果你希望使用不同于 `_reversa_sdd` 的输出文件夹名称，可以更改 `folder`。

---

## `config.user.toml`：个人偏好

用于你自己的偏好设置，不应提交：

```toml
[user]
name = "Your Name"
answer_mode = "chat"  # "chat" 或 "file"
```

!!! warning "不要提交"
    将 `config.user.toml` 添加到 `.gitignore` 中。每个团队成员可以有自己的偏好，互不影响。

---

## `plan.md`：探索计划

Reversa 在第一个会话中与你讨论项目后生成此文件。它按顺序列出了分析任务。

你可以直接编辑它：重新排序任务、移除你不想分析的模块、添加注释。Reversa 在恢复时会遵循其中的任何内容。

---

## 回答模式（`answer_mode`）

控制 Reviewer 如何向你提出验证问题：

| 模式 | 行为 |
|------|------|
| `chat`（默认） | 问题在聊天中逐个出现。你在对话中回答。 |
| `file` | Reviewer 生成一个 `_reversa_sdd/questions.md` 文件，包含所有问题。你填写完毕后告知完成。 |

当问题很多，你想按自己的节奏在会话之外回答时，`file` 模式很有用。

---

## 文档级别（`doc_level`）

定义每个 agent 在分析过程中生成的产物量。**不是在安装时配置的：** Reversa 在第一次分析会话开始阶段，Scout 绘制完项目概况后询问你，这样你可以根据真实信息来做决定。

| 值 | 适用场景 | 生成的产物 |
|---|----------|------------|
| `essencial` | 简单项目、脚本、原型 **（默认）** | 代码分析、领域、架构（C4 context）、SDD spec |
| `completo` | 中型项目、小型团队 | 基础级别的全部内容 + 完整 C4 图、ERD、ADR、OpenAPI、用户故事、可追溯性矩阵 |
| `detalhado` | 企业系统、高关键性 | 完整级别的全部内容 + 每个函数的流程图、扩展 ADR、部署图、强制交叉审查 |

选择保存在 `.reversa/state.json` 的 `doc_level` 字段中。你可以随时手动编辑它，在分析过程中调整级别。
