---
layout: post
title: Migrating to fish shell
date: 2021-10-10 09:34 +0900
category: Articles
tags: [tools shell]
---

I've been using `zsh` with [oh-my-zsh](https://ohmyz.sh) for the longest time because of its functionality, 
vast plugin eco-system, and quite frankly, the time I had sunk into customizing.  

## Basics

The fish equivalent for `.bashrc` or `.zshrc` is `~/.config/fish/config.fish`.  
There's a special kind of [scripting language](https://fishshell.com/docs/current/language.html) used 
in `fish` which is syntactically slightly different to bash.  
E.g. control statements like `if`, `while`, `for`, and also `function`s end with the keyword `end`.  
So there's some migration work to do depending on how extensive your current shell environment is set up.

## Abbreviations, Aliases, and Functions

- [Abbreviations](https://fishshell.com/docs/2.7/commands.html#abbr) will simply expand a short text into something longer after pressing space or enter.  
- [Functions](https://fishshell.com/docs/current/cmds/function.html) are written in `.fish` files and saved under `~/.config/fish/functions`.
- [Aliases](https://fishshell.com/docs/current/cmds/alias.html) can be defined via your `~/.config/fish/config.fish` file.

The problem here, with a bash alias I was able to type `which someAlias` to see what the command expanded into.  
In fish, `which` doesn't work that way for aliases.  

The documentation states that `alias` is a convenience wrapper for `function`. 
It will create a function that simply With the added benefit of automatically creating a description stating what the command expands into.

For example: 

```
alias lsa="ls -la"
```

will create a fish function with a description of `alias lsa=ls -la`. 

Which you can see by listing command completions via `tab`:
![image](/../assets/img/fish_alias_description.png)


## Prompt

There are lots of ways to customize the prompt in fish, even within fish itself.
I've settled with [starship](https://github.com/starship/starship) for now. It's written in Rust and very customizable, fast, and usable with many different shells. Not only fish.

> info ""
> Judging by the name and general appearance, starship seems to be inspired by the [spaceship](https://github.com/spaceship-prompt/spaceship-prompt) prompt for zsh.

Here's what my current setup looks like:

![image](/../assets/img/fish_starship.png)

The prompt itself shows the current path abbreviated up to the parent directory, the current branch name and status if the current directory is managed by git, followed by language environment information. Here it shows that the local Ruby version (managed by rbenv) for my Jekyll blog is `3.0.1`. 


## Other Software

Some software and Rust alternatives that I've been using since moving to fish.  
Most of these are not limited to fish, but general shell software packages.

### [exa]() replacing `ls`

![exa](/../assets/img/fish_exa.png)

> info ""
> The `LS_COLORS` settings are generated via [vivid](https://github.com/sharkdp/vivid).

### [dust](https://github.com/bootandy/dust) replacing `du`
![dust](/../assets/img/shell_dust.png)

### [procs](https://github.com/dalance/procs) replacing `ps`
![procs](/../assets/img/shell_procs.png)

### [zoxide](https://github.com/ajeetdsouza/zoxide) replacing `cd`

A smart directory changer that remembers and ranks visited paths, allowing you to use shortcuts when you want to go there again.

E.g. just typing `z project` when you want to navigate to `/some/folder/of/some/project`.


### [bottom](https://github.com/ClementTsang/bottom) replacing `top`

Hilarious naming.  
I'm used to [htop](https://htop.dev/) and `bottom` is less focused on the process list 
(which is covered by `procs` anyway) and provides additional visualization over time with graphs
for values like cpu, memory, and network throughput.

![bottom](/../assets/img/shell_bottom.png)

### [tealdeer](https://dbrgn.github.io/tealdeer/) replacing `tldr`

![tldr](/../assets/img/shell_tldr.png)
