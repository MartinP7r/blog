---
layout: post
title: Vim command for markdown headline
date: 2022-01-30 16:23 +0900
category:
- Snippets
tags:
- Vim
---
This is a sequence that I've been using quite a lot since I started to learn Vim.

I write a lot of markdown and for `H1` and `H2` headings I often use the *underlining* style of setting `===` or `---` under the title instead of prefixing `#` or `##`.  

```markdown
Heading 1
=========
instead of `#`

Heading 2
---------
instead of `##`
```

To make it visually more pleasing I like to have the underlining be as long as the title itself.  
The below sequence makes this really easy.

```
yyp // duplicate line
V   // select line
r=  // replace every character in the line with `=`
```

<video controls="controls" preload="preload" width="412" height="306">
  <source src="/assets/vim_md_headline.mp4" type="video/mp4">
</video>
