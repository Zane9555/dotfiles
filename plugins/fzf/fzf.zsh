# ══════════════════════════════════════════════════════════════════════
# FZF — Fuzzy Finder
# Turns your terminal into a searchable, preview-enabled powerhouse.
#
# What this gives you:
#   Ctrl+R  → Fuzzy search command history
#   Ctrl+T  → Fuzzy find files and insert path
#   Alt+C   → Fuzzy find directories and cd into them
#   Tab     → Fuzzy tab completion with previews (via fzf-tab)
#
# Requires: brew install fzf
# Optional: bat, eza, fd, ripgrep (for previews and faster search)
# ══════════════════════════════════════════════════════════════════════

# Bail if fzf isn't installed
(( $+commands[fzf] )) || return

# ── Color Theme (Tokyo Night) ─────────────────────────────────────────
# Matches dark terminals with blue/purple tones.
# Change this block to restyle all fzf menus at once.
export FZF_DEFAULT_OPTS="
    --color=fg:#c0caf5,bg:-1,hl:#7aa2f7:bold
    --color=fg+:#ffffff,bg+:#1f2335,hl+:#76b9e0:bold
    --color=info:#7aa2f7,prompt:#f7768e,pointer:#f7768e
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
    --color=border:#414868,query:#ddb6f2
    --color=gutter:-1

    --multi
    --border='rounded'
    --prompt='  '
    --pointer='▌'
    --marker=' '
    --info='inline'
    --height='45%'
    --layout='reverse'
    --padding='1'

    --bind 'ctrl-j:preview-down'
    --bind 'ctrl-k:preview-up'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-\:toggle-preview'
    --bind 'tab:down,shift-tab:up'
"
# ── /Color Theme ──────────────────────────────────────────────────────

# ── Search Backend ────────────────────────────────────────────────────
# Uses fd or ripgrep for speed, falls back to find.
# Skips .git, node_modules, __pycache__, .venv automatically.
if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude __pycache__ --exclude .venv"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --strip-cwd-prefix --exclude .git --exclude node_modules"
elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git' --glob '!node_modules'"
else
    export FZF_DEFAULT_COMMAND="find . -type f"
    export FZF_ALT_C_COMMAND="find . -type d"
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# ── /Search Backend ───────────────────────────────────────────────────

# ── Ctrl+T Preview (files) ────────────────────────────────────────────
if (( $+commands[bat] )); then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null' --bind 'ctrl-/:toggle-preview'"
else
    export FZF_CTRL_T_OPTS="--preview 'cat {} 2>/dev/null | head -500' --bind 'ctrl-/:toggle-preview'"
fi
# ── /Ctrl+T Preview ──────────────────────────────────────────────────

# ── Alt+C Preview (directories) ──────────────────────────────────────
if (( $+commands[eza] )); then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons --group-directories-first {} | head -200'"
elif (( $+commands[tree] )); then
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi
# ── /Alt+C Preview ───────────────────────────────────────────────────

# ── Context-Aware Tab Completion ──────────────────────────────────────
# When fzf is used for tab completion, show smart previews
# based on what command you're typing.
_fzf_compgen_dir() {
    if (( $+commands[fd] )); then
        fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1"
    else
        command find -L "$1" \( -name .git -o -name node_modules \) -prune -o -type d -print 2>/dev/null
    fi
}

_fzf_comprun() {
    local command=$1; shift

    case "$command" in
        cd|pushd)
            if (( $+commands[eza] )); then
                fzf "$@" --preview 'eza --tree --level=2 --color=always --icons --group-directories-first {} | head -200'
            else
                fzf "$@" --preview 'ls -1 --color=always {} | head -200'
            fi ;;
        vim|nvim|code|cat|bat|less)
            if (( $+commands[bat] )); then
                fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window 'right:60%'
            else
                fzf "$@" --preview 'cat {}'
            fi ;;
        export|unset)
            fzf "$@" --preview "printenv {}" --preview-window="bottom:3:wrap" ;;
        ssh)
            fzf "$@" --preview 'grep -A 4 "Host {}" ~/.ssh/config 2>/dev/null || echo "Host: {}"' ;;
        git)
            if (( $+commands[delta] )); then
                fzf "$@" --preview 'git diff --color=always {} | delta' --preview-window 'right:60%'
            else
                fzf "$@" --preview 'git diff --color=always {}' --preview-window 'right:60%'
            fi ;;
        *)
            fzf "$@" --preview '
                if [ -f {} ]; then
                    bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}
                elif [ -d {} ]; then
                    eza --tree --level=2 --color=always --icons {} 2>/dev/null || ls -1 {}
                else
                    echo {}
                fi' ;;
    esac
}
# ── /Context-Aware Tab Completion ─────────────────────────────────────

# ── Load fzf Shell Integration ────────────────────────────────────────
# Modern fzf (0.48+) uses this single command.
# Older versions need to source files from /opt/homebrew/opt/fzf/shell/
if [[ $(fzf --version 2>/dev/null | cut -d. -f1-2) > "0.47" ]]; then
    eval "$(fzf --zsh)"
else
    [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]   && source /opt/homebrew/opt/fzf/shell/completion.zsh
    [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
# ── /Load fzf Shell Integration ──────────────────────────────────────
