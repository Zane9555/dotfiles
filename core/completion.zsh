# ══════════════════════════════════════════════════════════════════════
# COMPLETION
# Initializes the zsh completion engine with a 24-hour cache.
# Instead of rebuilding the full completion database on every shell
# open, it reuses a cached dump file and only rebuilds once per day.
# ══════════════════════════════════════════════════════════════════════

autoload -Uz compinit

# Only rebuild the dump once every 24 hours
# (#qN.mh+24) is a zsh glob qualifier: file older than 24 hours
if [[ ! -f "$HOME/.zcompdump" || -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
    compinit -i -d "$HOME/.zcompdump"
    touch "$HOME/.zcompdump"
else
    compinit -C -d "$HOME/.zcompdump"
fi

# Allow completion to match dotfiles
_comp_options+=(globdots)
