# ══════════════════════════════════════════════════════════════════════
# PLUGIN MANAGER
# Lightweight plugin manager that clones GitHub repos and sources them.
# Plugins are downloaded to ~/.zsh/plugins/
#
# Usage:
#   plug "user/repo"                — load immediately
#   plug "defer" "user/repo"        — load after prompt draws (faster startup)
#
# To add a plugin: add it to the ZPLUGINS array below.
# To remove a plugin: delete it from ZPLUGINS and rm its folder from
#   ~/.zsh/plugins/
# ══════════════════════════════════════════════════════════════════════

ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"
[[ -d "$ZSH_PLUGIN_DIR" ]] || mkdir -p "$ZSH_PLUGIN_DIR"

function plug() {
    emulate -L zsh
    setopt localoptions extendedglob nullglob

    local -a targets
    (( $# > 0 )) && targets=("$@") || targets=("${ZPLUGINS[@]}")

    local repo name local_path entry_point enable_defer=0

    for repo in "${targets[@]}"; do
        # "defer" keyword flags the next plugin for lazy loading
        if [[ "$repo" == "defer" ]]; then
            enable_defer=1
            continue
        fi

        # Extract repo name: "user/repo" -> "repo"
        name="${repo:t}"
        local_path="$ZSH_PLUGIN_DIR/$name"

        # Clone if not already installed
        if [[ ! -d "$local_path" ]]; then
            print ":: Installing plugin: $name..."
            git clone --depth 1 --quiet "https://github.com/${repo}.git" "$local_path"
        fi

        # Find the entry point file
        local -a candidates=(
            $local_path/${name}.(plugin.zsh|zsh|sh)(N.)
            $local_path/*.(plugin.zsh|zsh|sh)(N.)
        )
        entry_point="${candidates[1]}"

        # Source it (deferred or immediate)
        if [[ -n "$entry_point" ]]; then
            if (( enable_defer )) && (( $+functions[zsh-defer] )); then
                zsh-defer source "$entry_point"
            else
                source "$entry_point"
            fi
        fi

        enable_defer=0
    done
}

# ── Your Plugins ──────────────────────────────────────────────────────
# Prefix with "defer" to lazy-load after prompt draws
typeset -a ZPLUGINS=(
    "defer" "hlissner/zsh-autopair"
    "defer" "zsh-users/zsh-autosuggestions"
    "defer" "zdharma-continuum/fast-syntax-highlighting"
)

# Load all plugins
plug
# ── /Your Plugins ─────────────────────────────────────────────────────
