# ══════════════════════════════════════════════════════════════════════
# MODERN TOOL ALIASES
# Replaces standard Unix tools with modern alternatives that have
# better output, colors, icons, and usability.
#
# Each alias only activates if the tool is installed.
# If a tool is missing, the original command is used as fallback.
#
# Tools used:
#   eza   → replaces ls  (icons, git status, colors)
#   bat   → replaces cat (syntax highlighting, line numbers)
#   fd    → replaces find (simpler syntax, respects .gitignore)
#   rg    → replaces grep (much faster, respects .gitignore)
#   delta → replaces diff (syntax highlighted side-by-side diffs)
# ══════════════════════════════════════════════════════════════════════

# ── ls → eza ──────────────────────────────────────────────────────────
# Requires a Nerd Font for icons to display correctly.
if (( $+commands[eza] )); then
    local _eza_opts="--group-directories-first --icons --color=always --hyperlink "

    alias ls="eza -G --git $_eza_opts"               # Default: long list, all files, git status
    alias l="eza -l --git $_eza_opts"                  # Long list with git status
    alias la="eza -a $_eza_opts"                       # All files (compact)
    alias ll="eza -l $_eza_opts"                       # Long list (no hidden files)
    alias lt="eza -aT --level=2 $_eza_opts"            # Tree view (2 levels deep)
    alias l.="eza -d .* $_eza_opts"                    # Dotfiles only
fi
# ── /ls → eza ─────────────────────────────────────────────────────────

# ── cat → bat ─────────────────────────────────────────────────────────
# Adds syntax highlighting, line numbers, and git integration to file viewing.
if (( $+commands[bat] )); then
    alias cat="bat"
fi
# ── /cat → bat ────────────────────────────────────────────────────────

# ── grep → ripgrep ────────────────────────────────────────────────────
# Much faster than grep, respects .gitignore, better defaults.
if (( $+commands[rg] )); then
    alias grep="rg"
fi
# ── /grep → ripgrep ──────────────────────────────────────────────────

# ── find → fd ─────────────────────────────────────────────────────────
# Simpler syntax, respects .gitignore, colorized output.
if (( $+commands[fd] )); then
    alias find="fd"
fi
# ── /find → fd ────────────────────────────────────────────────────────

# ── diff → delta ──────────────────────────────────────────────────────
# Syntax highlighted diffs with side-by-side view.
if (( $+commands[delta] )); then
    alias diff="delta"
fi
# ── /diff → delta ─────────────────────────────────────────────────────
