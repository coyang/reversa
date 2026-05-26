# Reviewer（审查员）

**命令：** `/reversa-reviewer`
**阶段：** 第 5 阶段 - 审查

---

## ⚖️ 规范审查员

Reviewer 拿着 Writer 的合同，试图从中找出漏洞：*"这是矛盾的。这一点没有证据。如果用户做了 X，这条规则就不成立了。"* 不是为了破坏，而是为了确保最终站得住脚的东西是牢固的。

---

## 功能说明

Reviewer 拿着 Writer 生成的合同，试图从中找出漏洞。不是为了破坏，而是为了确保最终站得住脚的东西是牢固的。

它寻找：同一规范内部的矛盾、不同规范之间的冲突、标记为 🟢 但实际上只是推断的声明、没有人文档化的显而易见的行为。当发现这些问题时，它会指出、纠正并重新分类。

---

## 额外功能：通过 Codex 进行交叉审查

如果会话中激活了 Codex 插件，Reviewer 提供一个特殊选项：在自身分析之前，请求 Codex 进行独立审查。

其优势在于从不同于生成规范的 LLM 获得第二意见。不同的模型会犯不同的错误，交叉审查能捕获单一审查可能遗漏的问题。

如果 Codex 不可用，Reviewer 正常运行，不会提及此功能。

---

## 审查流程

### 逐单元审查

对于 `<output_folder>/` 下的每个单元文件夹：

- 三个标准文件（`requirements.md`、`design.md`、`tasks.md`）是否存在？如果缺失，则是一个缺口。
- `requirements.md` 中的规则放在一起是否合理？是否存在内部矛盾？
- `design.md` 是否覆盖了 `requirements.md` 所承诺的内容？`tasks.md` 是否覆盖了二者？
- 是否存在明显未指定的行为？
- 标记为 🟢 的声明：Reviewer 会回到原始代码进行检查。必要时重新分类。

### 跨单元审查

- 互相冲突的单元
- 声明的依赖与代码中实际的依赖不匹配
- 应该存在但未生成的单元（与 Scout 的 `surface.json` 对比）

### 矩阵验证

- `code-spec-matrix.md`：是否完整？是否存在没有对应规范的代码文件？
- `spec-impact-matrix.md`：是否反映了真实的依赖关系？

### 向你提问

对于每个只有了解业务的人才能解决的 🔴 缺口，Reviewer 会创建一个格式化的问题。根据配置的 `answer_mode`：

**`chat`（默认）：** 问题直接逐条出现在聊天中。你在对话中回答，它会实时更新规范。

**`file`：** Reviewer 创建 `_reversa_sdd/questions.md` 包含所有问题。你按自己的节奏填写，完成后通知它。

---

## 产出文件

| 文件 | 内容 |
|------|------|
| `_reversa_sdd/questions.md` | 需要人工验证的问题 |
| `_reversa_sdd/confidence-report.md` | 每个规范的 🟢/🟡/🔴 计数及总体百分比 |
| `_reversa_sdd/gaps.md` | 仍未得到解答的缺口 |
| `_reversa_sdd/cross-review-result.md` | Codex 的发现（如果请求了交叉审查） |

`<output_folder>/` 下每个单元文件夹中的规范会被就地更新，带有重新分类后的结果。Reviewer 自身的输出（`questions.md`、`confidence-report.md`、`gaps.md`、`cross-review-result.md`）位于根目录，在单元文件夹之外。
