# Modern Tool Aliases

Replaces standard Unix commands with modern alternatives that look better and work smarter.

## What gets replaced

| You type | Actually runs | Why |
|----------|--------------|-----|
| `ls` | `eza -al --git --icons` | Icons, colors, git status, all files |
| `l` | `eza -l --git --icons` | Long list with git status |
| `la` | `eza -a --icons` | All files (compact view) |
| `ll` | `eza -l --icons` | Long list (no hidden files) |
| `lt` | `eza -aT --level=2 --icons` | Tree view, 2 levels deep |
| `l.` | `eza -d .* --icons` | Dotfiles only |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `grep` | `rg` (ripgrep) | 10x faster, respects .gitignore |
| `find` | `fd` | Simpler syntax, respects .gitignore |
| `diff` | `delta` | Syntax highlighted diffs |

## Requirements

Install the tools via Homebrew:

```
brew install eza bat fd ripgrep git-delta
```

Each alias only activates if the tool is installed. Missing tools fall back to the original command.

## Disable

Comment out the source line in `zshrc`:

```
# source "$DOTFILES_DIR/plugins/aliases/aliases.zsh"
```
