# Reversa

**将遗留系统转化为 AI agent 可执行的规格说明。**

你知道那个没人想碰的系统吗？就是那个已经跑了十年、每天都在产生收入，但没人真正了解其内部运行机制的系统？Reversa 就是为它而生的。

---

## 什么是 Reversa？

Reversa 是一个规格说明逆向工程框架。你将它安装到遗留项目中，激活你已经在使用的 AI agent，它会协调一组专家来分析代码，并生成完整、可追溯、任何编码 agent 都能直接使用的规格说明。

**换句话说：** Reversa 将没有文档的代码转化为可操作的契约，AI agent 可以理解并据此安全地演进系统。

---

## 快速开始

在遗留项目的根目录下：

```bash
npx reversa install
```

然后用你喜欢的 AI agent 打开项目，输入：

```
/reversa
```

就这么简单。Reversa 会接管并引导你走完全程。

---

## 你会在这里找到什么

<div class="grid cards" markdown>

- **Reversa 为什么存在**

    它解决了什么问题，以及为什么这很重要。

    [:octicons-arrow-right-24: 了解更多](por-que-reversa.md)

- **安装**

    两分钟即可开始。

    [:octicons-arrow-right-24: 安装](instalacao.md)

- **分析流水线**

    将代码转化为规格说明的 5 个阶段。

    [:octicons-arrow-right-24: 查看流水线](pipeline.md)

- **Agent**

    5 个专业团队：核心团队（始终安装）、迁移、代码正向工程、定价和翻译器。

    [:octicons-arrow-right-24: 查看 agent](agentes/index.md)

</div>

---

## 安全保障

!!! danger "💾 在开始之前备份你的项目"
    虽然 Reversa 从不修改你的文件，但 AI agent 可能会犯错。**我们强烈建议：**

    1. **用 Git 对项目进行版本管理** —— 在开始分析之前确保所有文件已提交
    2. **将仓库放在 GitHub**（或 GitLab、Bitbucket）上——这样你就有一个安全的远程副本
    3. **对项目文件夹做一个本地副本** —— 一个简单的 `cp -r my-project my-project-backup` 就能防范任何意外

    如果分析过程中发生意外，你可以通过 `git restore .` 或备份副本来恢复原始状态。

!!! warning "Reversa 从不触碰你的文件"
    Agent **仅**写入 `.reversa/` 和 `_reversa_sdd/`。你的项目中的任何文件都不会被修改、删除或覆盖。永远不。

!!! info "无需 API 密钥"
    Reversa 不请求、不存储、不传输任何服务的 API 密钥。智能来自你环境中已经在使用的 agent，如 Claude Code、Codex、Gemini CLI 等。
