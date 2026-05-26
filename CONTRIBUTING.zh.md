# 贡献指南

感谢你考虑为 Reversa 做贡献！Reversa 是一个多语言框架（代码、文档、生成的 spec 产物都支持 **English / 中文 / Português / Español**），因此贡献涵盖代码、prompt、文档与翻译多个维度。

[English version](./CONTRIBUTING.md)

---

## 目录

- [贡献方式](#贡献方式)
- [仓库结构（每个目录的作用）](#仓库结构每个目录的作用)
- [本地开发环境搭建](#本地开发环境搭建)
- [编辑 agent prompt（SKILL.md）](#编辑-agent-promptskillmd)
- [添加或改进翻译](#添加或改进翻译)
- [新增一种语言](#新增一种语言)
- [Pull Request 检查清单](#pull-request-检查清单)
- [代码与 prompt 风格](#代码与-prompt-风格)
- [发布流程](#发布流程)

---

## 贡献方式

| 类型 | 示例 |
|---|---|
| **缺陷报告** | 安装器崩溃、agent 输出错误、`state.json` 格式异常 |
| **新功能** | 新 agent、新编排命令、新模板 |
| **Prompt 优化** | 改进某个 `SKILL.md` 的指令、补充边界情况处理 |
| **翻译** | 新增或润色 `*.zh.md` / `*.pt.md` / `*.es.md` 文档；扩充 `GLOSSARY.zh.md` |
| **新语言** | 按 [新增一种语言](#新增一种语言) 步骤添加第五种语言（如 `ja`、`fr`、`de`） |
| **文档** | 改进 `README.md`、`docs/**`、补充图表 |
| **CI / 工具链** | npm 脚本、mkdocs 构建、链接检查 |

提交任何非平凡的 PR 前，**请先开 issue 讨论方案**，避免做无用功。

---

## 仓库结构（每个目录的作用）

```
reversa/
├── agents/                # Agent prompt（SKILL.md）—— 框架核心
│   ├── reversa/           #   主编排器
│   ├── reversa-scout/     #   Discovery：表层清单
│   ├── reversa-writer/    #   生成 spec 文件
│   └── ...                #   共约 49 个 agent
├── bin/reversa.js         # CLI 入口
├── lib/
│   ├── commands/          # install / update / status / uninstall …
│   ├── installer/         # prompts / detector / writer / manifest / validator
│   └── utils/             # banner / json-safe 等
├── templates/             # 复制到用户项目中的文件
│   ├── state.json         #   .reversa/state.json 模板
│   ├── config.toml        #   .reversa/config.toml 模板
│   ├── config.user.toml   #   .reversa/config.user.toml 模板
│   ├── documentation/     #   /reversa-docs 的 HTML 站点模板
│   ├── forward/           #   /reversa-forward 的正文模板
│   └── migration/         #   /reversa-migrate 的模板
├── docs/                  # mkdocs 站点源文件
│   ├── *.md               #   基准语言（英文）
│   ├── *.zh.md            #   简体中文
│   ├── *.pt.md            #   葡萄牙语
│   └── *.es.md            #   西班牙语
├── mkdocs.yml             # mkdocs 配置（含 i18n 插件）
├── package.json
├── CHANGELOG.md
└── README.md
```

**关键契约**（除非真的清楚后果，否则不要打破）：
- `state.json` 字段名（`preco_minimo`、`reconhecimento`、`escavacao` …）由 50+ 个 agent 共享，重命名会引发级联失败
- agent / template 的文件夹与文件名被 prompt 字面引用，重命名需要更新每一处引用
- `.reversa/` 与 `_reversa_sdd/` 是 agent **唯一允许写入**的路径，绝不要扩大这个范围

---

## 本地开发环境搭建

```bash
git clone https://github.com/sandeco/reversa.git
cd reversa
npm install
npm link        # 将 `reversa` 注册为全局符号链接，指向当前仓库
```

然后在任意 legacy 项目中：

```bash
cd /path/to/legacy-project
reversa install      # 用裸命令，**不要**用 `npx reversa`
```

修改任何 `agents/**/SKILL.md`、`templates/**`、`lib/**`，下一次在目标项目执行 `reversa install` 即可生效，**无需重新 `npm link`**。

取消链接：

```bash
cd /path/to/reversa
npm unlink -g reversa
```

更多验证命令与替代安装方式见 `README.md` → "Development mode"。

### 本地预览文档站点

```bash
pip install mkdocs mkdocs-material mkdocs-static-i18n
mkdocs serve     # http://127.0.0.1:8000/   (英文)
                 # http://127.0.0.1:8000/zh/ (中文)
                 # http://127.0.0.1:8000/pt/ (葡语)
                 # http://127.0.0.1:8000/es/ (西语)
```

---

## 编辑 agent prompt（SKILL.md）

Reversa 本质上是一个 **prompt 工程项目**，每个 `SKILL.md` 就是一个 AI agent 的操作手册。约定如下：

1. **`SKILL.md` 保持英文。** prompt 内嵌中英对照示例可以、且鼓励，但 prompt 结构本身保持英文。把整份 SKILL 翻译成另一种语言会显著降低 LLM 的推理质量。
2. **front-matter 是契约。** 文件顶部 YAML 会被某些引擎解析，不要破坏：
   - `name: <agent-id>` 必须与文件夹名一致
   - `description: ...` 会展示给用户
   - `compatibility: ...` 列出支持的引擎
3. **Language Contract 块必备。** 每个 SKILL 都必须包含一节 "Language Contract"，从 `.reversa/state.json` 读取 `chat_language` 与 `doc_language`。请参考既有 SKILL（搜索 "Language Contract" 或 "doc_language is 中文"）作为模板。
4. **`agents/<agent>/references/*.md` 参考文件**同样优先英文撰写；用户可见标签可以多语言。
5. **不要引入语言相关的控制关键字。** 统一使用 [`agents/reversa/references/confirmation-keywords.md`](agents/reversa/references/confirmation-keywords.md)。
6. **至少在两种引擎上测试**（如 Claude Code + Codex）。

---

## 添加或改进翻译

### 文档（`docs/`）

- 文件命名：`name.md`（英文基准）、`name.pt.md`、`name.zh.md`、`name.es.md`
- mkdocs-static-i18n 插件自动路由，**新增中文文件无需**在 `mkdocs.yml` 单独注册；**若改了导航标签**则需要补充 `nav_translations` 条目
- 添加 `name.zh.md` 时做一次平行度自检：行数、章节结构应与 `name.md` 大致对应。差异过大说明有问题

### 术语

- 翻译正文**之前**先更新 [`agents/reversa/references/GLOSSARY.zh.md`](agents/reversa/references/GLOSSARY.zh.md)，一致性比文采更重要
- 标题翻译放在同一文件的 "Spec 标题映射表" 一节

### 生成的 spec 输出

- spec 内容语言由 `state.json` 中的 `doc_language` 控制。翻译规则属于 agent SKILL（Language Contract）和术语表，**不要硬编码**到 prompt 各处

### 翻译评审

- 接受非母语者提交，但 reviewer 必须是母语者。如无母语 reviewer，@sandeco
- **仅机器翻译（未经人工润色）的 PR 不会合并**。可以用 MT 起稿，但必须人工修订

---

## 新增一种语言

想加入比如日语？完整清单如下：

1. **`lib/installer/prompts.js`** — 在 `chat_language` 与 `doc_language` choices 中加入新选项
2. **`templates/state.json` / `templates/config.toml`** — 保留默认值或在注释中注明新语言
3. **`agents/reversa/SKILL.md`** Language Contract — 在规则表中加入新语言
4. **`agents/reversa/references/GLOSSARY.{lang}.md`** — 复制 `GLOSSARY.zh.md` 结构，为新语言建术语表
5. **`agents/reversa/references/confirmation-keywords.md`** — 加入新语言的 `continue` / `stop` 关键字
6. **`mkdocs.yml`** — 在 `plugins.i18n.languages` 下新增 `- locale: <lang>` 块，含完整 `nav_translations`
7. **`docs/*.<lang>.md`** — 翻译全部 39 个基准语言 `.md` 文件（可分批落地）
8. **`README.md`** — 添加指向 `https://sandeco.github.io/reversa/<lang>/` 的徽章
9. **`CHANGELOG.md`** — 在下一个版本下加条目
10. **`templates/documentation/assets/css/style.css`** — 若新语言需要特殊字体（CJK / RTL …），扩展字体栈

---

## Pull Request 检查清单

提 PR 前：

- [ ] 分支已与 `main` 同步
- [ ] 提交原子化，msg 形如 `<type>: <short description>`（`feat: …`、`fix: …`、`docs: …`、`chore: …`、`i18n: …`、`prompt: …`）
- [ ] 若改动了 `agents/**`，已在示例 legacy 项目跑 `reversa install` 并目视验证
- [ ] 若改动了 `templates/state.json` / `templates/config.toml`，同步更新了 `agents/reversa/references/state-schema.md`
- [ ] 若新增了 agent，已加入：
  - `lib/installer/prompts.js`（team 映射）
  - `agents/reversa/SKILL.md`（编排器的 plan）
  - `docs/agentes/<agent>.md`（含 `.zh.md` / `.pt.md` / `.es.md` 翻译）
- [ ] 若改动了任何英文 SKILL / 文档中的用户可见字符串，翻译同步更新 **或** 显式标注 "translations to follow in a separate PR"
- [ ] `mkdocs build --strict` 通过（无失效链接 / 缺失导航）
- [ ] `CHANGELOG.md` 在 `## [Unreleased]` 下有条目（若该节不存在则新建）

---

## 代码与 prompt 风格

- **JS / Node**：仅 ESM（`package.json` 中 `type: "module"`），禁用 CommonJS
- **Python**（`templates/` 与 `agents/*/scripts/` 下）：目标 Python 3.10+，使用类型注解，docstring 英文
- **Markdown**：ATX 标题（`#`），代码块带语言标签（`` ```python ``），重复 URL 可用引用式链接
- **Prompt**：流程优先用编号列表，不变量优先用项目符号列表。避免含糊措辞（"you may want to consider…"），agent 需要明确指令
- **文件名**：仅 ASCII、小写、连字符分隔。路径中**绝不**使用空格、重音字符或非 ASCII 字符

---

## 发布流程

仅 maintainer：

1. 按 SemVer 更新 `package.json` 的 `version`
2. 在 `CHANGELOG.md` 加新版本节
3. 打 tag：`git tag v1.x.y && git push --tags`
4. `npm publish --access public`
5. mkdocs 通过 GitHub Pages 在 push 到 `main` 时自动部署

---

## 行为准则

请友善、具体、善意推定。我们遵循 [Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/zh-hans/)。

---

## 许可证

提交贡献即表示你同意将贡献按 [MIT License](./LICENSE) 授权。
