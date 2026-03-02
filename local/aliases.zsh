# ══════════════════════════════════════════════════════════════════════
# ALIASES & SHORTCUTS
# Personal aliases and directory shortcuts.
# ══════════════════════════════════════════════════════════════════════

# TODO: Port from ~/.zshrc.backup when ready
# Automatically parse a tool's help menu and generate a permanent, zero-delay static cache file
completion() {
    local cmd=$1
    if [[ -z "$cmd" ]] || ! command -v "$cmd" >/dev/null; then
        echo "Usage: cache-comp <command>"
        return 1
    fi

    local comp_dir="$HOME/.zsh/completions"
    local comp_file="$comp_dir/_$cmd"
    mkdir -p "$comp_dir"

    echo "Parsing $cmd --help..."
    
    # Run help once and extract all flags (-f, --flag)
    local raw_flags=($($cmd --help 2>/dev/null | command grep -oE -- '^\s*(-[a-zA-Z0-9]|--[a-zA-Z0-9_-]+)'))

    if [[ ${#raw_flags[@]} -eq 0 ]]; then
        echo "❌ Could not find any flags. Does '$cmd --help' output a standard menu?"
        return 1
    fi

    # Write the static completion file
    echo "#compdef $cmd" > "$comp_file"
    echo "_arguments -s \\" >> "$comp_file"
    
    # Format and deduplicate flags into Zsh syntax
    for flag in ${(u)raw_flags}; do
        flag=$(echo "$flag" | xargs) # strip whitespace
        echo "  '$flag' \\" >> "$comp_file"
    done

    # Force Zsh to rebuild the database to cache the new file
    rm -f ~/.zcompdump*
    echo "✅ Cached static completion to $comp_file"
    echo "🔄 Run 'exec zsh' to apply and experience zero delay."
}