# ══════════════════════════════════════════════════════════════════════
# EVAL CACHE
# Caches the output of slow init commands (starship, zoxide, etc.)
# Instead of running `eval "$(tool init zsh)"` every shell open,
# this runs it once, saves the output to a file, and sources that file.
# Auto-invalidates when the binary changes (e.g. after brew upgrade).
#
# Usage: _eval_cache "binary_name" "full init command"
# Cache location: ~/.cache/zsh-cache/eval-cache/
# ══════════════════════════════════════════════════════════════════════

_EVAL_CACHE_DIR="$HOME/.cache/zsh-cache/eval-cache"
[[ -d "$_EVAL_CACHE_DIR" ]] || mkdir -p "$_EVAL_CACHE_DIR"

function _eval_cache() {
    local name="$1"
    local cmd="$2"
    local cache_file="$_EVAL_CACHE_DIR/${name}.zsh"
    local binary="$commands[$name]"

    # If the tool isn't installed, skip silently
    [[ -z "$binary" ]] && return

    # Rebuild cache if: file missing OR binary has been updated
    if [[ ! -f "$cache_file" || "$binary" -nt "$cache_file" ]]; then
        local tmp_file="${cache_file}.$$"
        if eval "$cmd" > "$tmp_file" 2>/dev/null; then
            mv -f "$tmp_file" "$cache_file"
        else
            rm -f "$tmp_file"
            return 1
        fi
    fi

    source "$cache_file"
}
