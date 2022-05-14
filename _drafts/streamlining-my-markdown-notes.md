---
layout: post
title: Streamlining my Markdown Notes
date: 2022-02-06 06:34 +0900
category: [Articles, Projects]
tags: [scripts, swift, automation]
---

I've been keeping a git repository with all of my notes, snippets, ideas, etc...
The folder structure is something like:

```
📂 daybook
+- 📂 2022
   +- 📁 01
   +- 📂 02
      +- 📄 2022-02-01.md
      +- 📄 2022-02-02.md
      +- 📄 ...
📂 snippets
+- 📄 awesome_swift_script.md
+- 📄 that_cli_command_i_always_forget.md
+- 📄 ...
📁 wiki
```

Usually, when I start my day, I create a new file and necessary folders in my daybook folder.  
That's where I note things I learn throughout the day, todos and ideas that I want keep track of.

```md
---
date: 2022-02-01
category: daybook
---

**TODO**

- [ ] Check Mail
- [ ] Check Schedule
- [ ] Make Coffee

Work Log
========

// ...

```
In the snippets folder I keep code snippets and helpful shell one-liners that I can easily search for.

the front matter is for searchability. I use vscode with Vim plugin for editing.

So I create new files, insert the template, fill in the date, copy unfinished todos from the day before, etc...

I wanted to automated more of this process. And what better way to procrastinate on my actual projects than writing a shell application from scratch that does all that for me.


