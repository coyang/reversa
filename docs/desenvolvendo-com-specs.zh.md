# 从 spec 进行开发

当 Reversa 在 `_reversa_sdd/` 中生成所有 spec 后，你可以将这些文件带到任何机器上，从头开始构建系统。以下是推荐的顺序。

---

## 在写任何一行代码之前

首先阅读这三个文件：

| 文件 | 为什么先阅读 |
|------|--------------|
| `_reversa_sdd/confidence-report.md` | 显示哪些是高置信度（绿色）vs. 空白（红色）。避免基于错误的推断进行构建。 |
| `_reversa_sdd/gaps.md` | 列出 Reversa 无法确定的内容。在开始之前手动填写这些。 |
| `_reversa_sdd/architecture.md` + C4 图 | 展示全局视图：层次、模块、系统边界。 |

---

## 实现顺序（自底向上）

```
1. database/  +  erd-complete.md             （数据结构、migration）
2. domain.md  +  <unit>/ 核心实体            （核心业务规则：阅读每个单元的 requirements.md、design.md、tasks.md）
3. 按依赖排序的 <unit>/ 服务                  （使用 dependencies.md 作为指南）
4. openapi/   +  API 契约                    （如果有的话）
5. ui/                                       （表现层最后）
```

---

## 哪个单元先开始

打开 `_reversa_sdd/traceability/code-spec-matrix.md`。它列出了每个单元及其依赖关系。

先实现不依赖任何其他单元的单元（依赖树中的叶子节点），然后逐步向上，实现集成多个组件的单元。

---

## 在开发过程中保持可追溯性

在开发时，使用 `_reversa_sdd/traceability/code-spec-matrix.md` 作为参考，了解哪一段已实现的代码对应哪个 spec。随着代码库的增长，这可以保持可追溯性的准确。

---

## 另请参阅

- [生成的输出](saidas/index.md)：Reversa 产生的文件的完整列表
- [置信度等级](escala-confianca.md)：如何解读 spec 中的 🟢🟡🔴 标记
