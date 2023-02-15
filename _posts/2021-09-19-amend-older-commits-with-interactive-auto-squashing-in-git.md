---
layout: post
title: Amend older commits with interactive auto-squashing in Git
category: [Snippets]
tags: git tools
date: 2021-09-18 17:59 +0900
---

Here is an interesting way of amending (fixing) an older commit in Git.

Sometimes I realize not right away that a file wasn't included in commit and I've already commited on top of it.
Now I can't just go `git commit --amend` in order to add my staged fixes to the most recent commit.

Given some commit history

```
* 97e4b90 - Commit 3 (7 minutes ago) <Me>
* 9cf741e - Commit 2 (7 minutes ago) <Me>
* c4c839c - Commit 1 (60 minutes ago) <Me>
```

> the easy-on-the-eyes history graph above can be produced using the `glol` alias provided by **oh-my-zsh**, which expands to
> `git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'`.
{: .prompt-tip }

Where I want to add some changes to `Commit 2` I can use

```sh
# stage the changes you want to commit 
git commit -m "fixup! 9cf741e"
# interactive rebase with autosquash
git rebase e8adec4^ -i --autosquash
```

Which will display the fixup already in the right position lined up with the other commits ready to be autosquashed.

```
pick 9cf741e Commit2
fixup 823aa63 fixup! 9cf741e
pick 97e4b90 Commit3
```

`fixup` is explained in the rebase screen as:

```
# f, fixup <commit> = like "squash", but discard this commit's log message
```

Keep in mind that this will change all commit hashes from the fixed commit forward to the most recent commit.
This can potentially break history for your collaborators should you choose to force push a fixed branch to a remote that has already been fetched/pulled by others.
