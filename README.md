# ⏩ zsh-kickstart

> [!IMPORTANT]
> zsh-kickstart is in early development, although it is already perfectly
> usable in its current condition.

## 💡 Introduction

zsh-kickstart is a minimal starting point to build your own zsh configuration.
Its objective is:

- not compromise performance
- to be as unopinionated as possible
- document every decision made so that the user understands how and why
they should modify their configuration

This is **NOT a framework** like Oh My Zsh and Prezto and there is no abstraction,
what you see is the raw zsh configuration.

Based on tjdevtries' kickstart.nvim.

## ⚙️ Usage

> [!WARNING]
> Backup your .zshrc file as this will replace it.

```sh
curl https://raw.githubusercontent.com/warbacon/zsh-kickstart/main/.zshrc > "$HOME/.zshrc"
```

Done.

## 🧻 FAQ

> Will you add plugins?

Not by default, but probably will add a section of recommended plugins and
how to install one.

> The default prompt is ugly and boring.

It needs to be boring so that it works for a person who doesn't need
additional information at the prompt and to be as fast as possible. I don't
think it's pretty but not ugly either, you can suggest a new style if you see
fit.
