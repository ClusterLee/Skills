---
name: whiteprint
description: 工程白图（whiteprint）风格的 HTML 报告/幻灯片生成器。纸白网格底 + 靛蓝墨线 + 橙红(风险/重)/青绿(通过/轻)语义配色，Zilla Slab + Noto Serif SC + IBM Plex Mono。支持两种产出：垂直滚动的长页报告(webpage) 和 分页翻页的 deck（默认 3:4 竖版、适配小红书），并可用 headless Chrome 把 deck 逐页导出成 PNG 图片。适用于：硬核技术/架构/研究类报告、方案文档、小红书技术图文、需要工程图纸/规格书质感的演示。当用户要"工程白图风格""技术规格书风""蓝图/白图风报告""做小红书技术图文的 HTML"时使用。
agent_created: true
---

# whiteprint · 工程白图

一套**自包含**的工程白图风格 HTML 生成系统：从模板出发，稳定产出统一风格的报告与幻灯片。纸白网格底 + 靛蓝墨线 + 工程图元素（title block / 裁切标记 / 剖面线 / 修订记录），配色用语义化双强调色（**橙红 = 风险/升权/重**，**青绿 = 通过/兼容/轻**）。

## 它能产出什么

| 模式 | 形态 | 适用 | 尺寸 |
|---|---|---|---|
| **webpage** | 垂直滚动长页 | 报告、方案文档、发链接阅读 | 1040px 居中自适应 |
| **deck** | 分页翻页幻灯片 | 演讲、小红书图文 | 3:4 竖版 1080×1440（默认）/ 16:9 / 1:1 |

deck 配套 **render.sh**：用 headless Chrome 把每页导成 PNG，直接发小红书。

## 目录结构

```
whiteprint/
├── SKILL.md                  (本文件)
├── assets/
│   ├── fonts.css             (Google Fonts: Zilla Slab / Noto Serif SC / Noto Sans SC / IBM Plex Mono)
│   ├── base.css              (设计 token + 全部可复用组件 —— 两模式共用)
│   ├── webpage.css           (长页模式布局)
│   ├── deck.css              (deck 模式布局 + slide 画布)
│   └── runtime.js            (deck 翻页 / hash 深链 #/N / 缩放适配)
├── templates/
│   ├── webpage.html          (长页模板，含全部组件示例，可直接打开预览)
│   └── deck.html             (deck 模板，6 页示例，可直接打开预览)
└── scripts/
    ├── new-deck.sh           (脚手架：生成自包含实例)
    └── render.sh             (渲染：deck 逐页导 PNG)
```

## 快速开始

**1. 生成一个实例**（推荐用脚手架，产出自包含、可打包分享）：

```bash
# 分页 deck（默认 3:4 竖版，小红书）
bash ~/.workbuddy/skills/whiteprint/scripts/new-deck.sh ~/WorkBuddy/某主题/dist deck 3:4

# 16:9 横版 deck（演讲）
bash ~/.workbuddy/skills/whiteprint/scripts/new-deck.sh ~/WorkBuddy/某主题/dist deck 16:9

# 长页报告
bash ~/.workbuddy/skills/whiteprint/scripts/new-deck.sh ~/WorkBuddy/某主题/dist webpage
```

生成后编辑 `dist/index.html` 填入内容，浏览器打开预览。

**2. 导出 PNG（发小红书）**：

```bash
# 逐页渲染，默认 1080x1440 @2x（清晰，适合小红书）
bash ~/.workbuddy/skills/whiteprint/scripts/render.sh ~/WorkBuddy/某主题/dist/index.html 6

# 自定义页数/输出目录/尺寸
bash ~/.workbuddy/skills/whiteprint/scripts/render.sh dist/index.html 6 shots 1920,1080
```

产物在 `dist/shots/slide-N.png`。

## 编写规则（重要）

1. **从模板出发**，不要从零写。webpage 用 `templates/webpage.html`，deck 用 `templates/deck.html`。
2. **用 token，不写死颜色**。颜色/字体一律 `var(--ink)`、`var(--warn)`、`var(--pass)`、`var(--f-display)` 等。语义：风险/重/升权用 `--warn`（橙红），通过/轻/兼容用 `--pass`（青绿），墨线用 `--ink`。
3. **优先组合现有组件**，不要发明新组件。组件清单见下。
4. **配色克制**：主色靛蓝 + 最多两个强调色（橙红/青绿），不要彩虹配色。
5. **deck 每页一件事**：一张 slide 讲清一个点，信息量克制，竖版卡片优先 `c2` 两列。
6. **SVG 图**：用工程图语言——细线（1~1.5px）、剖面线 `<pattern>`（dots/hatch/cross，deck 模板里有现成 defs）、引线标注。剖面线密度 = 重量/强度。

## deck 内容编排与填充密度（生成 deck 必读）

3:4 竖版画布 1080×1440，比 16:9 高不少，**内容编排是 deck 质量的关键**。两条铁律 + 填充手法 + 技术坑 + 自查清单。

### 铁律一：禁止用 CSS 拉伸撑满画布
- 不要用 `flex:1` 撑高 + `grid-auto-rows:1fr` + `justify-content:center` 强行拉伸卡片填满——会让**卡片内部出现大片空洞**（内容被挤到下半），纯属"为填充而填充"。
- 卡片 / 表格 / 机制一律**按内容自然高度**；宁可卡片之间有正常留白，也不让卡片内部空洞。

### 铁律二：每页一个主题并讲明白，密度不多不少
- 页首加一句**点题**：这页讲什么、解决什么问题。
- 正文把概念 / 方法的**是什么、为什么、解决什么问题**讲清楚。反面案例：只给对比表 + 结论，却不解释概念本身（如只摆"链式 vs 树式"对比表，没说清什么是链式 / 树式）——读者看不懂。
- 抽象 / 对比类概念**优先配 SVG 示意图**（如链式 y1→y2→y3✗ 与树式分支对照）。
- 密度**不多不少**：既别下半大片空，也别硬塞。

### 填充的正确手法（靠内容编排，不靠拉伸）
1. **充实单卡**：标题 + 多行正文（例子 / 数据 / 解释）+ `.kv>.chip` 关键词。
2. **补有效内容块**：补充说明卡、对比 duo、要点列表——须与该页主题强相关，不是堆字。
3. **底部锚点吸底**：takeaway / `.callout` / `.limit` / 时间线用 `margin-top:auto` 吸到页脚上方（真实内容收尾，合理）。
4. 表格 / 机制列表用**自然行距**，别硬撑 padding。

### 技术坑（渲染前必查）
- **SVG**：`viewBox` 高度要贴合图形内容（图形 y 坐标从 viewBox 顶部起算），否则 SVG 顶部留白。
- **中文乱码**：写完 HTML 后、render 前，用 python 扫描 `U+FFFD` / surrogate（个别中文字可能被写成乱码字节），`bad_chars==0` 才渲染。
- **渲染**：`bash scripts/render.sh <deck.html> <页数>`，产物在 `shots/slide-N.png`。

### 生成后自查清单
- [ ] 每页是否一个主题、且讲明白了（是什么 / 为什么 / 解决什么）？
- [ ] 有无 CSS 拉伸造成的卡片内部空洞？
- [ ] 填充密度是否适中（无大片空白、无硬塞）？
- [ ] SVG 是否贴合（无顶部 / 底部大留白）？
- [ ] 扫描乱码 `bad_chars==0` 后才渲染？

## 组件清单（base.css）

- **结构**：`.titleblock`（工程标题栏）· `.eyebrow` · `h1.wp-title` · `.lede` · `.sec-head`+`.sec-no`+`.sec-title`+`.sec-sub` · `.rule`
- **强调**：`.thesis[data-label]`（核心命题框）· `.hl`（青绿高亮）· `.hlw`（橙红高亮）
- **卡片**：`.cards.c2/c3/c4` + `.wp-card`（可带 `.pno` 编号、`.en` 英文副题、`.kv>.chip` 关键词）
- **机制**：`.mechs>.mech`（`.mno` 大编号 + `.mbody`）
- **表格**：`table.wp-table` + `.verdict.pass/.mid/.warn` 判定标签
- **案例/结论**：`.casecard.ok/.heavy`（带落点标）· `.callout`（结论条，`.warn` 变体）
- **边界**：`.limit`（橙红边条）/ `.limit.info`（墨蓝边条）
- **其它**：`.rev`（修订记录）· `.figcap`（图注）
- **动效**：`.reveal`（滚动淡入）· `.draw`（SVG 线条绘制）· `.fade`（SVG 延迟淡入）

## 切换风格 / 主题

本 skill 是**单一风格**（工程白图），不做多主题。如需别的风格，改 `assets/base.css` 里 `:root` 的 token（`--paper`/`--ink`/`--warn`/`--pass`/字体）即可全局换肤，结构与组件不变。

## 依赖与离线

- 字体走 Google Fonts CDN（`assets/fonts.css`）；**离线时回退系统字体**，排版结构不受影响。
- 渲染依赖本机 Google Chrome（`render.sh` 自动探测，找不到会提示）。
- 除字体外无其他外部依赖，实例自包含、可离线打开、可打包分享。
