# ══════════════════════════════════════════════════════════════════════
# FZF-TAB — Fuzzy Tab Completion
# Replaces zsh's default tab menu with fzf's fuzzy search interface.
# Press Tab on any command and get a searchable, preview-enabled menu.
#
# Loaded via plugin manager. This file configures its behavior.
#
# Source: https://github.com/Aloxaf/fzf-tab
# ══════════════════════════════════════════════════════════════════════

# Bail if fzf-tab isn't loaded yet (it's loaded by plugin-manager)
(( $+functions[fzf-tab-complete] )) || return

# ── Disable Default Menu ──────────────────────────────────────────────
# Let fzf-tab handle all completion menus instead of zsh's built-in
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:descriptions' format '[%d]'
# ── /Disable Default Menu ─────────────────────────────────────────────

# ── Behavior ──────────────────────────────────────────────────────────
# Typing / while completing a path automatically dives deeper
zstyle ':fzf-tab:*' continuous-trigger '/'

# Switch between completion groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# Use LS_COLORS in the completion list
zstyle ':fzf-tab:*' list-colors ${(s.:.)LS_COLORS}

# Space accepts the selection, Enter accepts and runs
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line enter
# ── /Behavior ─────────────────────────────────────────────────────────

# ── Previews ──────────────────────────────────────────────────────────
# Default: show file contents or directory listing
zstyle ':fzf-tab:complete:*:*' fzf-preview \
    'if [[ -d $realpath ]]; then
        eza -1 --color=always --icons --group-directories-first $realpath 2>/dev/null || ls -1 $realpath
     elif [[ -f $realpath ]]; then
        bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || cat $realpath
     fi'

# cd: show tree view of the directory
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza --tree --level=2 --color=always --icons --group-directories-first $realpath 2>/dev/null || ls -1 $realpath'

# kill: show process details
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview \
    'ps -p $group -o pid,user,%cpu,%mem,command 2>/dev/null'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags \
    '--preview-window=down:3:wrap'
# ── /Previews ─────────────────────────────────────────────────────────

# ── Styling ───────────────────────────────────────────────────────────
zstyle ':fzf-tab:*' fzf-flags \
    --height=45% \
    --pointer '>' \
    --color 'pointer:green:bold' \
    --color 'bg+:-1:,fg+:green:bold,hl+:yellow:bold,hl:gray:bold' \
    --color 'info:blue:bold,marker:yellow:bold' \
    --color 'gutter:-1' \
    --bind 'ctrl-\:toggle-preview'
# ── /Styling ──────────────────────────────────────────────────────────
