# dotfiles

Personal zsh configuration.

## What do I edit to change...

| I want to... | Edit this file |
|---|---|
| Add/remove shell behaviors (auto-cd, globbing, etc.) | `core/options.zsh` |
| Change history size or behavior | `core/history.zsh` |
| Change how tab completion works | `core/completion.zsh` |
| Change keyboard shortcuts | `core/keybinds.zsh` |
| Add/remove a third-party zsh plugin | `engine/plugin-manager/plugin-manager.zsh` |
| Switch prompt theme | `prompt/themes.zsh` (change `PROMPT_THEME`) |
| Add/remove a tool (zoxide, etc.) | Add/remove its folder in `plugins/` and a `source` line in `zshrc` |
| Change PATH or fpath | `local/path.zsh` |
| Add personal aliases or shortcuts | `local/aliases.zsh` |
| Disable a whole feature | Comment out its `source` line in `zshrc` |

## Setup

```
gh repo clone Zane9555/dotfiles ~/dotfiles
ln -s ~/dotfiles/zshrc ~/.zshrc
exec zsh
```

## Structure

```
zshrc                            ← Sources everything. Comment out a line to disable it.
core/                            ← Shell fundamentals (options, history, completion, keybinds)
engine/
  defer/                         ← Lazy loading engine (zsh-defer)
  plugin-manager/                ← Auto-clones GitHub plugins
prompt/                          ← Async git engine + themes
plugins/
  zoxide/                        ← Smart cd
  autopair/                      ← Auto-close brackets/quotes
  autosuggestions/                ← Ghost text from history
  syntax-highlighting/           ← Command coloring
local/                           ← Your personal config (PATH, aliases)
```

Every file has comments explaining what it does.
Each folder has its own README.
