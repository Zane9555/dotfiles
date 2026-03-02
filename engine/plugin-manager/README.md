# Plugin Manager

Lightweight plugin manager that clones GitHub repos and sources them.

## Where plugins are downloaded

`~/.zsh/plugins/` — this is separate from the dotfiles repo so cloned plugin code doesn't clutter your config.

## How to add a plugin

Edit the `ZPLUGINS` array in `manager.zsh`:

```zsh
typeset -a ZPLUGINS=(
    "defer" "hlissner/zsh-autopair"
    "defer" "zsh-users/zsh-autosuggestions"
    "defer" "zdharma-continuum/fast-syntax-highlighting"
    "some-user/new-plugin"              # loaded immediately
    "defer" "some-user/another-plugin"  # loaded after prompt draws
)
```

Then restart your shell: `exec zsh`

## How to remove a plugin

1. Delete it from the `ZPLUGINS` array in `manager.zsh`
2. Delete its folder: `rm -rf ~/.zsh/plugins/plugin-name`
3. Restart: `exec zsh`

## What "defer" does

Prefixing a plugin with `"defer"` means it loads **after** your prompt appears using the zsh-defer engine. This makes startup feel instant. Use it for plugins that aren't needed in the first millisecond (syntax highlighting, autosuggestions, etc.).

## Current plugins

| Plugin | What it does |
|--------|--------------|
| `hlissner/zsh-autopair` | Auto-closes brackets, quotes, etc. |
| `zsh-users/zsh-autosuggestions` | Ghost text suggestions from history |
| `zdharma-continuum/fast-syntax-highlighting` | Colors commands as you type (green = valid, red = error) |
