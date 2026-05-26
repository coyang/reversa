# 参与贡献

欢迎贡献。如果你发现了 bug、有新 agent 的想法，或者想改进某些东西，流程很简单。

---

## 在提交 PR 之前

先开一个 issue 讨论你想修改什么。这避免了双方浪费时间，特别是对于较大的改动。

---

## 本地设置

```bash
git clone https://github.com/sandeco/reversa.git
cd reversa
npm install
```

---

## 项目结构

```
reversa/
├── agents/             ← 每个 agent 有其文件夹及 SKILL.md
├── bin/                ← CLI 入口点（reversa.js）
├── lib/
│   ├── commands/       ← CLI 命令实现
│   └── installer/      ← 安装和引擎检测逻辑
├── templates/          ← 配置模板和引擎入口文件
└── docs/               ← 文档（你在这里）
```

---

## 添加新的 agent

1. 创建文件夹 `agents/reversa-[name]/`
2. 按照现有 agent 的格式创建 `SKILL.md`（必需的 frontmatter：`name`、`description`、`license`、`compatibility`、`metadata`）
3. 如果 agent 需要 schema 或参考模板，添加一个 `references/` 文件夹
4. 更新 `lib/installer/` 以在安装列表中包含新的 agent

---

## 许可证

MIT。详见 [LICENSE](https://github.com/sandeco/reversa/blob/main/LICENSE)。
