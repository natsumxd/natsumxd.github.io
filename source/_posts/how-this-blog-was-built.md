---
title: 这个博客是怎么搭起来的
title_en: How this blog was built
summary_zh: Hexo 7 + 一套自己写的暖色主题 + GitHub Pages，全部免费。顺便记下以后怎么发文、怎么部署。
summary_en: Hexo 7, a hand-written warm theme, and GitHub Pages — all free. Plus notes on writing and deploying.
date: 2026-11-02 10:10:00
categories: 技术
tags: [Hexo, GitHub Pages, 教程]
---

{% lang zh %}
这篇是写给我自己看的备忘录：这套博客是怎么组起来的，以后想改哪里该去哪个文件。

## 技术栈

| 部分 | 选择 | 原因 |
| --- | --- | --- |
| 生成器 | Hexo 7 | Node 生态，模板就是 EJS，改起来直观 |
| 主题 | warm（自己写的） | 想要暖色调 + 真正的中英切换 |
| 托管 | GitHub Pages | 免费、稳定、自定义域名也支持 |
| 搜索 | hexo-generator-searchdb | 纯前端，不需要服务器 |

## 目录结构

```bash
blog/
├── _config.yml          # 站点配置：标题、作者、URL、部署
├── scripts/
│   └── tag-lang.js      # 双语标签插件
├── source/
│   ├── _posts/          # 文章都放这里
│   ├── about/           # 关于页
│   ├── tags/            # 标签总览页
│   └── search/          # 搜索页
└── themes/warm/
    ├── _config.yml      # 主题配置：菜单、问候语、头像
    ├── layout/          # EJS 模板
    └── source/          # css / js / images
```

## 写一篇新文章

```bash
cd blog
npx hexo new post "文章标题"
```

然后打开 `source/_posts/` 下新生成的文件，用双语标签把内容分开写：

```markdown
{% lang zh %}
这里是中文内容，可以正常用 Markdown。
{% endlang %}

{% lang en %}
English content here. Markdown works as usual.
{% endlang %}
```

页面上只会显示当前选中的那一种语言；右上角的按钮负责切换，选择会记在浏览器里。

## 本地预览

```bash
npx hexo server
```

打开 http://localhost:4000 ，改完存盘刷新就行。

## 发布上线

```bash
npx hexo clean && npx hexo generate    # 生成静态文件到 public/
./deploy.sh                            # 提交并推送到 GitHub Pages
```

推送之后等一两分钟，`https://natsumxd.github.io` 就会更新。

## 想改外观时

- 颜色、字号、间距：`themes/warm/source/css/style.css` 顶部的 `:root` 变量
- 导航菜单、首页问候语：`themes/warm/_config.yml`
- 站点标题、作者、社交链接：`blog/_config.yml`

{% endlang %}

{% lang en %}
A note to future me: how this blog is put together, and which file to open when I want to change something.

## The stack

| Piece | Choice | Why |
| --- | --- | --- |
| Generator | Hexo 7 | Node ecosystem, templates are plain EJS, easy to tweak |
| Theme | warm (hand-written) | Warm palette plus a real bilingual switch |
| Hosting | GitHub Pages | Free, stable, custom domains supported |
| Search | hexo-generator-searchdb | Pure front-end, no server needed |

## Directory layout

```bash
blog/
├── _config.yml          # site config: title, author, URL, deploy
├── scripts/
│   └── tag-lang.js      # the bilingual tag plugin
├── source/
│   ├── _posts/          # posts live here
│   ├── about/           # about page
│   ├── tags/            # tag overview
│   └── search/          # search page
└── themes/warm/
    ├── _config.yml      # theme config: menu, greeting, avatar
    ├── layout/          # EJS templates
    └── source/          # css / js / images
```

## Writing a new post

```bash
cd blog
npx hexo new post "Post title"
```

Then open the new file in `source/_posts/` and split the content by language:

```markdown
{% lang zh %}
Chinese content here. Regular Markdown works.
{% endlang %}

{% lang en %}
English content here.
{% endlang %}
```

Only the active language is displayed; the button in the header switches it and remembers the choice.

## Preview locally

```bash
npx hexo server
```

Open http://localhost:4000 and refresh after each save.

## Publishing

```bash
npx hexo clean && npx hexo generate    # build into public/
./deploy.sh                            # commit and push to GitHub Pages
```

One or two minutes after the push, `https://natsumxd.github.io` updates.

## Where to tweak the look

- Colors, type scale, spacing: the `:root` variables at the top of `themes/warm/source/css/style.css`
- Menu, hero greeting: `themes/warm/_config.yml`
- Site title, author, social links: `blog/_config.yml`

{% endlang %}
