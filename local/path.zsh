# ══════════════════════════════════════════════════════════════════════
# PATH & FPATH
# Directories your shell searches for commands and completions.
# Without these, Homebrew tools (brew, git, zoxide, etc.) won't be found.
# ══════════════════════════════════════════════════════════════════════

# ── PATH ──────────────────────────────────────────────────────────────
# Homebrew (Apple Silicon installs to /opt/homebrew)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Local binaries (pip install --user, custom scripts, etc.)
export PATH="$HOME/.local/bin:$PATH"
# ── /PATH ─────────────────────────────────────────────────────────────

# ── FPATH (completion search path) ────────────────────────────────────
# Homebrew-installed completions + your own custom completions
fpath=(/opt/homebrew/share/zsh/site-functions ~/.zsh/completions $fpath)
# ── /FPATH ────────────────────────────────────────────────────────────

# ── EZA(ls replacement) Themes ────────────────────────────────────
export EZA_CONFIG_DIR="$HOME/.config/eza"
# ── /EZA(ls replacement) Themes ────────────────────────────────────

