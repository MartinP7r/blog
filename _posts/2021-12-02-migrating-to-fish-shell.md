---
layout: post
title: Migrating to fish shell
date: 2021-10-10 09:34 +0900
category: Articles
tags:
- tools
- shell
---

`zsh` enhanced by [oh-my-zsh](https://ohmyz.sh) has been my shell of choice for the longest time.  
Partly because of its functionality and vast plugin eco-system, but quite frankly, also because of the time I had sunk into customizing it to my requirements.

So, I might be a little late to the party, but I've decided to give the very popular fish shell a shot.
Below I summarized some of the features and other software I've started using in the process of migrating to fish.

> This article is likely to change over time as I might be adding or replacing the tools I'm using.
{: .prompt-warning }

## Basics

The fish equivalent of `.bashrc` or `.zshrc` is `~/.config/fish/config.fish`.  
There's a special kind of [scripting language](https://fishshell.com/docs/current/language.html) used 
in `fish` which is syntactically slightly different to bash.  
E.g. block-based control statements like `if`, `while`, `for`, as well as `function`s close with the keyword `end`.  
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

> Judging by the name and general appearance, starship seems to be inspired by the [spaceship](https://github.com/spaceship-prompt/spaceship-prompt) prompt for zsh.
{: .prompt-info }

Here's what my current setup looks like:

![image](/../assets/img/fish_starship.png)

The prompt itself shows the current path abbreviated up to the parent directory, the current branch name and status if the current directory is managed by git, followed by language environment information. Here it shows that the local Ruby version (managed by rbenv) for my Jekyll blog's source folder is `3.0.1`. 

## Plugins

### [autopair.fish](https://github.com/jorgebucaran/autopair.fish)

Auto-completes brackets and quotes. I.e. typing `"` will produce `""` and put the cursor in between the two.

### [fzf.fish](https://github.com/PatrickF1/fzf.fish)

This enhances several search features on the command line with fuzzy search and a visually nice interface.

![fzf](/../assets/img/fish_fzf.gif)

## Other Software

Some software and Rust alternatives that I've been using since moving to fish.  
Most of these are not limited to fish, but general shell software packages.

### [exa]() replacing `ls`

![exa](/../assets/img/fish_exa.png)

> The `LS_COLORS` settings seen above are generated via [vivid](https://github.com/sharkdp/vivid).
{: .prompt-tip }

### [dust](https://github.com/bootandy/dust) replacing `du`

![dust](/../assets/img/shell_dust.png)

### [procs](https://github.com/dalance/procs) replacing `ps`

![procs](/../assets/img/shell_procs.png)

### [zoxide](https://github.com/ajeetdsouza/zoxide) replacing `cd`

A smart directory changer that remembers and ranks visited paths, allowing you to use shortcuts when you want to go there again.

E.g. just typing `z project` when you want to navigate to `/some/folder/of/some/project`.


### [bottom](https://github.com/ClementTsang/bottom) replacing `top`

Hilarious naming.  
I've grown fond of [htop](https://htop.dev/), however, `bottom`'s focus is less on the process list 
(which is covered by `procs` anyway) and makes space for additional visualization over time with graphs
for values like CPU, memory, and network throughput.

![bottom](/../assets/img/shell_bottom.png)

### [tealdeer](https://dbrgn.github.io/tealdeer/) replacing `tldr`

A replacement for `tldr`. It's showing common usages and parameters for shell commands at a glance.
I haven't delved into customizing it too much, yet. But I already love how compact it looks.

![tldr](/../assets/img/shell_tldr.png)

## Honorable mentions

### [grex](https://github.com/pemistahl/grex)

RegEx is hard and this tool does a great job at guessing which expression you want based on the input you provide.  
Check out the video on their [GitHub repository](https://github.com/pemistahl/grex) to see what I mean.
Personally, I'm probably not using regex enough to remember this tool the next time I'd need it, but it might be helpful to you.

### [ripgrep](https://github.com/BurntSushi/ripgrep)

A very fast alternative to grep

### [bandwhich](https://github.com/imsnif/bandwhich)

If you need a more detailed rundown on your current network connections and the bandwidth their taking up

### [xh](https://github.com/ducaale/xh)

A clean and easy tool for sending http requests


## TODO

Packages that seem interesting, but I haven't had the time to look at, yet.

- [https://github.com/denisidoro/navi](https://github.com/denisidoro/navi)
- [https://github.com/extrawurst/gitui](https://github.com/extrawurst/gitui)
- [https://github.com/dandavison/delta](https://github.com/dandavison/delta)
- [https://github.com/extrawurst/gitui](https://github.com/extrawurst/gitui)
- [https://github.com/sharkdp/fd](https://github.com/sharkdp/fd)
- [https://github.com/sharkdp/bat](https://github.com/sharkdp/bat)
- [https://github.com/muesli/duf](https://github.com/muesli/duf)
  - maybe even better: [https://github.com/Byron/dua-cli](https://github.com/Byron/dua-cli)

## References

- [https://github.com/TaKO8Ki/awesome-alternatives-in-rust](https://github.com/TaKO8Ki/awesome-alternatives-in-rust)
