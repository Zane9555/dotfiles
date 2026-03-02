# zsh-defer

Inline port of [romkatv/zsh-defer](https://github.com/romkatv/zsh-defer).

## What it does

Queues commands to run **after** your prompt appears, while the shell is idle. This is what makes deferred plugin loading fast — your prompt shows instantly, then heavy stuff loads in the background.

## Usage

```zsh
# Defer sourcing a slow plugin
zsh-defer source "/path/to/plugin.zsh"

# Defer an eval command
zsh-defer -c 'eval "$(slow-tool init zsh)"'
```

## Should I edit this?

Probably not. This is infrastructure that other things depend on. The plugin manager (`plugins/manager/`) uses it automatically when you prefix a plugin with `"defer"`.
