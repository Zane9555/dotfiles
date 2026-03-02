# ══════════════════════════════════════════════════════════════════════
# ZOXIDE
# Smarter cd that learns your most-used directories.
# After visiting a directory once, you can jump to it from anywhere
# by typing just part of the name: cd dotfiles, cd SwapSmart, etc.
#
# How cd works now:
#   cd <full path>    → Normal cd behavior
#   cd <partial name> → Zoxide fuzzy jumps to best match
#   cd + Tab          → fzf picker showing BOTH local dirs and zoxide history
#
# Requires: brew install zoxide
# Uses eval-cache so it only runs `zoxide init` once.
# ══════════════════════════════════════════════════════════════════════

# Initialize zoxide, replacing cd with its smart version
_eval_cache "zoxide" "zoxide init zsh --cmd cd"

# ── Zoxide + fzf interactive picker ───────────────────────────────────
# Quick jump: type 'cdi' to open zoxide's full directory history in fzf
function cdi() {
    local selected
    selected=$(zoxide query -l 2>/dev/null | \
        fzf --height=45% --layout=reverse --border \
            --prompt="cd → " \
            --query="$*" \
            --preview 'eza -1 --color=always --icons --group-directories-first {} 2>/dev/null || ls -1 {}' \
            --preview-window='right:50%' \
            --bind 'ctrl-\:toggle-preview')

    [[ -n "$selected" ]] && cd "$selected"
}

# ── Custom completion for cd ──────────────────────────────────────────
# Merges zoxide history with local directory listing for cd completion.
# This means cd + Tab shows directories you've visited before AND
# directories in the current folder.
function _cd_zoxide_complete() {
    # Get zoxide results
    local -a zoxide_dirs
    if (( $+commands[zoxide] )); then
        zoxide_dirs=("${(@f)$(zoxide query -l 2>/dev/null)}")
    fi

    # Get local directory results (default behavior)
    local -a local_dirs
    local_dirs=("${(@f)$(find . -maxdepth 1 -type d ! -name '.' 2>/dev/null | sed 's|^\./||')}")

    # Combine: zoxide first (most useful), then local
    local -a all_dirs
    all_dirs=($zoxide_dirs $local_dirs)

    # Remove duplicates
    typeset -U all_dirs

    compadd -Q -U -- "${all_dirs[@]}"
}

# Register the custom completer for cd
compdef _cd_zoxide_complete cd 2>/dev/null
# ── /Custom completion ────────────────────────────────────────────────
