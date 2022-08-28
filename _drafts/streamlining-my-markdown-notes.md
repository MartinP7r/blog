---
layout: post
title: Automating daily file generation with a Swift commandline script
date: 2022-08-26 13:37 +0900
category: [Articles, Projects]
tags: [scripts, swift, automation]
---


I am keeping a git repository with all of my notes, snippets, ideas, etc...
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
This is basically an engineering journal, where I note things I learn throughout the day, todos and ideas that I want keep track of.

Here's a typical outline of a file:

```md
---
date: 2022-02-01
category: daybook
---

**TODO**

- [ ] Make Coffee
- [ ] Check Mail
- [ ] Write Blog

Work Log
========

// ...

```

the front matter is for searchability. I use vscode with Vim plugin for editing.

So I create new files, insert the template, fill in the date, copy unfinished todos from the day before, etc...

I wanted to automate more of this process. And what better way to procrastinate on my actual projects than writing a shell application from scratch that does all that for me.  
Ideally I'd just type something like `make daybook` and it generates the new files and folders, moves ToDos if necessary and opens the new daybook file.

Just like in my general Swift Commandline Tool article [LINK], we're going to use an executable swift package.

```terminal
swift package init --type executable
```
