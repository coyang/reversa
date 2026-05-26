# Design System（设计系统）

**命令：** `/reversa-design-system`
**阶段：** 任意阶段

---

## 🎨 造型师

造型师对衣橱进行分类：调色板、字体、间距、设计 token。支配系统外观的"时尚规则"——什么可以组合、什么不可以。

---

## 功能说明

造型师对系统的衣橱进行分类：调色板、字体、间距、设计 token。支配项目外观的"时尚规则"——什么可以组合、什么不可以。

当你需要重写界面或创建新组件同时保持与现有内容的外观一致性时非常有用。

---

## 分析来源

Design System 使用任何可用的资源：

1. **CSS/SCSS/LESS：** CSS 变量（`--color-primary`）和 Sass 变量（`$color-primary`）
2. **Tailwind CSS：** 包含自定义主题的 `tailwind.config.js`
3. **UI 库：** MUI（`createTheme`）、Chakra UI（`extendTheme`）、Mantine、Ant Design
4. **styled-components / Emotion：** 通过 `ThemeProvider` 提供的主题对象
5. **Token 文件：** Style Dictionary、`tokens.json`、`design-tokens.yaml`
6. **Storybook：** 如果存在，分析组件变体的 stories
7. **截图：** 作为确认 token 的可视化补充

---

## 文档化内容

### 调色板

主色、次要色和强调色；中性色；反馈色（成功、错误、警告、信息）；变化色调（50 到 900 或 light/main/dark），包含 hex/rgb/hsl 值。

### 字体排版

字体族及后备字体、字号缩放比例、可用的字重、默认行高和字间距、层级（h1 到 h6、body、caption、label、code）。

### 间距和布局

基础间距缩放比例、网格（列数、间距、最大宽度）、断点（sm、md、lg、xl、2xl，单位为 px）。

### 其他 token

边框圆角、阴影和层级、z-index 缩放比例、过渡和缓动函数、语义化透明度。

### 组件

如果有自定义组件库：组件列表、变体和主要属性。

---

## 产出文件

| 文件 | 内容 |
|------|------|
| `_reversa_sdd/design-system/color-palette.md` | 包含值的完整调色板 |
| `_reversa_sdd/design-system/typography.md` | 字体排版系统 |
| `_reversa_sdd/design-system/spacing.md` | 间距、网格和断点 |
| `_reversa_sdd/design-system/tokens.md` | 表格形式的所有 token |
| `_reversa_sdd/design-system/design-system.md` | 综合文档 |
