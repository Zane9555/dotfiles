# Carapace — Universal Command Completion Engine

Provides tab completions for 500+ CLI tools automatically. If a command doesn't ship its own zsh completions (like `repomix`, `bun`, `cargo`, etc.), carapace fills the gap.

## How It Works

Carapace registers itself as a completion provider for hundreds of commands at once. When you press Tab, it provides the flags, subcommands, and arguments — and fzf-tab renders them as a fuzzy-searchable menu.

It also has a **bridge mode** that pulls completions from fish, bash, and inshellisense shells, so even tools without any official completion support get basic completions.

## Examples

```
repomix --<Tab>     → Shows all repomix flags with descriptions
cargo build --<Tab> → Shows all cargo build flags
docker run <Tab>    → Shows container images
brew install <Tab>  → Shows available packages
```

## Requirements

```
brew install carapace
```

## Supported Commands

See the full list at: https://carapace-sh.github.io/carapace-bin/completers.html

Includes: git, docker, brew, cargo, npm, bun, ssh, kubectl, terraform, gh, and 500+ more.

## Disable

Comment out the source line in `zshrc`:

```
# source "$DOTFILES_DIR/plugins/carapace/carapace.zsh"
```
