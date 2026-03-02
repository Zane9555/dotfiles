# ══════════════════════════════════════════════════════════════════════
# ZOXIDE
# Smarter cd that learns your most-used directories.
# Usage: z <partial-directory-name>
# Requires: brew install zoxide
# Uses eval-cache so it only runs `zoxide init` once.
# ══════════════════════════════════════════════════════════════════════

_eval_cache "zoxide" "zoxide init zsh"
