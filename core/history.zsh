# ══════════════════════════════════════════════════════════════════════
# HISTORY
# Controls how zsh saves and shares command history.
# ══════════════════════════════════════════════════════════════════════

setopt SHARE_HISTORY             # Share history across all open terminals
setopt INC_APPEND_HISTORY_TIME   # Write to history file immediately
setopt EXTENDED_HISTORY          # Save timestamps with commands
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries
setopt HIST_IGNORE_SPACE         # Don't save commands starting with space
setopt HIST_REDUCE_BLANKS        # Clean up whitespace in history
setopt HIST_VERIFY               # Show expanded command before running

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
