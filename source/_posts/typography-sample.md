---
title: 一篇排版样本
title_en: A typography sample
summary_zh: 标题、引用、列表、表格、代码块——顺手留一页参考，看看这个主题把它们排成什么样。
summary_en: Headings, quotes, lists, tables, and code blocks — a reference page for how this theme sets them.
date: 2026-11-01 21:00:00
categories: 随笔
tags: [示例]
---

{% lang zh %}
这篇文章不写什么正经内容，只是把主题的排版元素都摆出来，方便以后对照。

## 二级标题长这样

正文的字号是 16.5px，行高 1.85，读长文的时候眼睛不容易累。段落之间有 1.25em 的间距。

### 三级标题会小一些

再往下是四级标题，颜色更淡一点。

> 引用块用的是衬线字体，左边一条细细的陶土色竖线。
>
> 适合放一句想强调的话。

### 列表

无序列表：

- 第一项
- 第二项，稍微长一点，看看换行之后的样子
- 第三项

有序列表：

1. 先做这个
2. 再做那个
3. 最后收尾

### 表格

| 项目 | 说明 | 状态 |
| --- | --- | --- |
| 写作 | 用 Markdown 手写 | 进行中 |
| 设计 | 暖色 + 衬线标题 | 完成 |
| 部署 | GitHub Pages | 完成 |

### 代码

行内代码看起来像 `const x = 1`，代码块则是这样：

```javascript
function greet(name) {
  // 慢一点，但清楚一点
  return `你好，${name}`;
}

greet('世界');
```

## 一句话结尾

排版是无声的语气。它不抢戏，但你一眼就能感觉到它有没有被认真对待。

{% endlang %}

{% lang en %}
This post has no real content. It just lays out the theme's typographic elements so I can compare against them later.

## A level-two heading looks like this

Body text is 16.5px with 1.85 line height — easy on the eyes over long reads. Paragraphs breathe at 1.25em.

### Level three is a little smaller

Below that, level four is lighter in color.

> Blockquotes use the serif face with a thin terracotta rule on the left.
>
> Good for a line worth emphasizing.

### Lists

Unordered:

- First item
- Second item, a bit longer, to see how it wraps
- Third item

Ordered:

1. Do this first
2. Then that
3. Wrap up

### Tables

| Item | Notes | Status |
| --- | --- | --- |
| Writing | Hand-written Markdown | Ongoing |
| Design | Warm palette, serif headings | Done |
| Deploy | GitHub Pages | Done |

### Code

Inline code looks like `const x = 1`, and blocks look like this:

```javascript
function greet(name) {
  // slower, but clearer
  return `Hello, ${name}`;
}

greet('world');
```

## One last line

Typography is a silent tone of voice. It never shows off, yet you can tell at a glance whether it was taken seriously.

{% endlang %}
