# 夏日手帖 · natsumxd 的博客

Hexo 7 + 自制主题 `warm`（雾蓝配色、中英双语）+ GitHub Pages。

线上地址：https://natsumxd.github.io

## 常用命令

本地路径：`/Users/huangxiaodong/Documents/blog`

```bash
cd /Users/huangxiaodong/Documents/blog

npx hexo server          # 本地预览 http://localhost:4000
./post.sh list           # 列出所有文章
./post.sh new "标题"      # 新建文章
./post.sh del 关键词      # 删除文章（移入 .trash/，可恢复）
./deploy.sh              # 构建并发布到 GitHub Pages
```

## 写文章

新文件在 `source/_posts/`，用双语标签分段写，页面只显示当前语言：

```markdown
---
title: 中文标题
title_en: English title
summary_zh: 首页卡片上的中文摘要
summary_en: English summary for the card
date: 2026-11-02 10:00:00
categories: 随笔
tags: [标签1, 标签2]
---

{% lang zh %}
中文正文，正常写 Markdown。
{% endlang %}

{% lang en %}
English body, Markdown works as usual.
{% endlang %}
```

## 改外观

| 想改什么 | 改哪个文件 |
| --- | --- |
| 主色、字号、间距、圆角 | `themes/warm/source/css/style.css` 顶部 `:root` 变量 |
| 导航菜单、首页问候语、页脚格言 | `themes/warm/_config.yml` |
| 站名、副标题、作者、社交链接 | `_config.yml` |
| 头像、favicon | `themes/warm/source/images/` |

常用配色变量（亮色 / 暗色各一套，在 `style.css` 里）：

- `--bg` 页面底色 · `--card` 卡片底色 · `--ink` 正文色
- `--accent` 主色（链接、下划线、强调）· `--accent-soft` 浅色底
- `--line` 分隔线 · `--sage` 分类标签色

## 部署说明

仓库 `natsumxd.github.io` 的 `main` 分支根目录即线上内容；`deploy.sh` 会把 `public/` 复制到临时目录、以 `main` 分支强推上去。

若之后绑定自定义域名：在 `source/` 放一个 `CNAME` 文件（内容为域名），并在 GitHub 仓库 Settings → Pages 里填写。
