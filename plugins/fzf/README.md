# FZF — Fuzzy Finder + Tab Completion

Turns your terminal into a searchable, preview-enabled interface.

## Keybindings

| Key | What it does |
|-----|-------------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files, insert path at cursor |
| `Alt+C` | Fuzzy find directories and cd into them |
| `Tab` | Fuzzy tab completion with context-aware previews |
| `Ctrl+J/K` | Scroll preview up/down |
| `Ctrl+\` | Toggle preview panel |
| `Ctrl+A` | Select all results |

## How Tab Completion Works

When you press Tab, fzf-tab replaces the default completion menu with a fuzzy search. What you see in the preview depends on context:

- **`cd <Tab>`** → Tree view of each directory
- **`vim <Tab>`** → Syntax-highlighted file contents
- **`ssh <Tab>`** → SSH config details
- **`git <Tab>`** → Colored diffs
- **Everything else** → File contents or directory listing

## Color Theme

Uses Tokyo Night colors by default. Change the `FZF_DEFAULT_OPTS` color block in `fzf.zsh` to restyle everything.

## Files

| File | Purpose |
|------|---------|
| `fzf.zsh` | Core fzf config (colors, keybindings, search backend, shell integration) |
| `fzf-tab.zsh` | fzf-tab plugin config (previews, styling, behavior) |

## Requirements

```
brew install fzf
```

fzf-tab is loaded automatically by the plugin manager.

## Disable

Comment out the source lines in `zshrc`:

```
# source "$DOTFILES_DIR/plugins/fzf/fzf.zsh"
# source "$DOTFILES_DIR/plugins/fzf/fzf-tab.zsh"
```
