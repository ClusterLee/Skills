# Skills

个人 AI skills 集合（WorkBuddy / Claude Code / AgentSkill 生态）。

每个子目录是一个独立、自包含的 skill，可单独克隆、安装、使用。

## 已有 Skills

| Skill | 说明 | 速览 |
|---|---|---|
| [**whiteprint**](./whiteprint) | 工程白图风格的 HTML 报告 / 幻灯片生成器。纸白网格底 + 靛蓝墨线 + 橙红(风险/重)/青绿(通过/轻)语义配色，Zilla Slab + Noto Serif SC + IBM Plex Mono。支持长页报告(webpage)与小红书 3:4 翻页 deck，可逐页导 PNG。 | `webpage` · `deck 3:4/16:9/1:1` · `render.sh` |

> whiteprint 适用于：硬核技术 / 架构 / 研究类报告、方案文档、小红书技术图文、需要工程图纸 / 规格书质感的演示。

## 安装

```bash
# 克隆仓库
git clone https://github.com/ClusterLee/Skills.git

# 把需要的 skill 复制到你的 skills 目录（WorkBuddy 示例）
cp -R Skills/whiteprint ~/.workbuddy/skills/

# 或用 AgentSkill CLI
npx skills add https://github.com/ClusterLee/Skills
```

安装后重启你的 Agent，skill 即生效。

## whiteprint 用法速览

```bash
# 生成长页报告
bash ~/.workbuddy/skills/whiteprint/scripts/new-deck.sh ~/WorkBuddy/某主题/dist webpage

# 生成小红书 3:4 翻页 deck
bash ~/.workbuddy/skills/whiteprint/scripts/new-deck.sh ~/WorkBuddy/某主题/dist deck 3:4

# 逐页渲染为 PNG（发小红书）
bash ~/.workbuddy/skills/whiteprint/scripts/render.sh dist/index.html 6
```

详细规则、组件清单、deck 内容编排指南见 [`whiteprint/SKILL.md`](./whiteprint/SKILL.md)。

## License

MIT
