# Zoxide

Smarter `cd` that learns your most-used directories.

## Install

```sh
brew install zoxide
```

## Usage

```sh
z projects       # jumps to ~/Projects (or wherever you cd'd to most with "projects" in the name)
z swap            # jumps to your SwapSmart folder if you've been there before
zi                # interactive fuzzy picker (requires fzf)
```

## How it works here

Uses `_eval_cache` from `core/eval-cache.zsh` so `zoxide init zsh` only runs once. The cached output is stored in `~/.cache/zsh-cache/eval-cache/zoxide.zsh` and auto-refreshes if the zoxide binary changes.

## To disable

Comment out this line in `zshrc`:

```zsh
# source "$DOTFILES_DIR/plugins/zoxide/zoxide.zsh"
```
