# Documentation Team（文档团队）

Documentation Team 将 Reversa 其他部分提取的知识转化为一个自包含的 HTML 迷你站点，直接从磁盘提供。无需构建服务器，查看时无需互联网连接：每个库、每个数据集、每个视觉资源都在本地 vendored（内嵌）。

使用以下命令激活：

```
/reversa-docs
```

orchestrator 检测哪些来源可用（`_reversa_sdd/`、`.reversa/soul.md`、`.reversa/chronicle.md`、源代码），运行一个简短的三问题访谈来选择读者画像、深度和视觉风格，然后按固定顺序驱动四个专家 agent。

---

## 什么时候使用

你已经运行过 `/reversa`，并希望让某人——新开发者、非技术利益相关者、审计团队——能够在不需要阅读原始 Markdown 的情况下浏览已提取的内容。迷你站点对入门引导有自己的理念：3D Code City 用于空间直觉，仪表盘用于量化概览，术语表加幻灯片用于叙述。

在纯 greenfield 项目中（未检测到任何来源），orchestrator 会询问是中止还是仅生成最小化的索引页面。

---

## Pipeline

```
/reversa-docs                   (orchestrator)
       │
       ▼ 阶段 0: vendor bundle
       │   将 Three.js、D3、Highcharts、OrbitControls
       │   下载到 assets/vendor/，以便 file:// 离线工作
       │
       ▼ 阶段 1
Mapper        → arquitetura.html (Code City 3D)
              → modulos.html (D3 力导向图)
              → topologia.html (遗留 vs 现代并排对比)
       │
       ▼ 阶段 2
Analyst       → metricas.html (Highcharts treemap、sankey、histogram、columns)
              → timeline.html (来自 .reversa/chronicle.md 的事件)
       │
       ▼ 阶段 3
Storyteller   → glossario.html (客户端搜索)
              → deck.html (6 到 10 张可导航幻灯片)
              → features/<spec>.html (每个 SDD spec 一个页面)
       │
       ▼ 阶段 4
Publisher     → index.html，带有 hero 和独特的 generative seal
              → 自动发现辅助 HTML
              → 链接验证和本地遥测
```

每个 agent 之间有一个 `CONTINUAR` 检查点。添加 `--auto` 可跳过访谈和暂停。

---

## 产出物存放位置

所有产出物存放在 `.reversa/documentation/` 下。该团队**从不**修改核心产出物（`_reversa_sdd/`、`.reversa/soul.md`、`.reversa/chronicle.md`），只读取它们。

```
.reversa/documentation/
├── index.html              (Publisher: hero、seal、nav)
├── arquitetura.html        (Mapper)
├── modulos.html            (Mapper)
├── topologia.html          (Mapper，如果检测到拓扑)
├── metricas.html           (Analyst)
├── timeline.html           (Analyst，如果 chronicle 存在)
├── glossario.html          (Storyteller)
├── deck.html               (Storyteller)
├── features/
│   └── <spec>.html         (Storyteller，每个 SDD spec 一个页面)
├── viewer.html             (共享 shell)
├── assets/
│   ├── vendor/             (Three.js、D3、Highcharts……)
│   ├── js/data.js          (Publisher: 注入 window.RV_DATA)
│   └── data/*.json         (agent 之间的中间缓存)
├── .config.json            (访谈、seed、视觉风格)
└── .state.json             (pipeline 遥测，每个页面的 hash)
```

如果 `.reversa/documentation/` 已经存在，orchestrator 提供六种重新生成选项（保留、重新生成全部、重新生成单个 agent 或页面、重做访谈……），并在覆盖之前始终创建一个 `.backup-<timestamp>/`。

---

## 不变量

该团队生成的每个页面都遵守四个不变量。Publisher 是最终守护者，但任何违反这些不变量的 agent 都会破坏迷你站点：

1. **通过 `file://` 工作**：双击 `index.html` 就足够了。没有任何页面对本地文件发起 `fetch()`（CORS 会阻止 origin `null`）；数据来自 `window.RV_DATA.<key>`，由 `assets/js/data.js` 注入。
2. **离线工作**：没有 `<script src="https://...">` 指向 CDN。每个外部库都在 `assets/vendor/` 中 vendored。
3. **Nav 反映 `pagesGenerated`**：`viewer.html` 中的 `<!-- NAV_LINKS -->` 标记由 Publisher 读取 `.state.json.pagesGenerated` 来填充。被省略的页面不会出现。
4. **声明成功前进行冒烟测试**：Publisher 启动一个本地 `http.server`，获取每个页面并 grep 错误模式。失败会在最终摘要中显示。

---

## 下一步

- [4 个视觉 agent](agentes.md)：每个 agent 渲染什么、输入和输出。
- [Code Forward Agents](../forward/index.md)：该团队构建于其上的循环。
