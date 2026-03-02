# ══════════════════════════════════════════════════════════════════════
# ASYNC GIT ENGINE
# Runs git status in a background process so your prompt never freezes.
# Sets global variables that prompt themes read to display branch/status.
#
# Global variables set by this engine:
#   GIT_IS_REPO        — 1 if current dir is a git repo, 0 if not
#   GIT_BRANCH         — current branch name (truncated to 20 chars)
#   GIT_HAS_MODIFIED   — 1 if there are modified files
#   GIT_HAS_UNTRACKED  — 1 if there are untracked files
#   GIT_HAS_STAGED     — 1 if there are staged files
#
# You shouldn't need to edit this file.
# The themes in themes.zsh read these variables to build the prompt.
# ══════════════════════════════════════════════════════════════════════

zmodload zsh/stat 2>/dev/null
autoload -Uz add-zsh-hook

# ── State Variables ───────────────────────────────────────────────────
typeset -g GIT_BRANCH="" GIT_IS_REPO=0
typeset -g GIT_HAS_MODIFIED=0 GIT_HAS_UNTRACKED=0 GIT_HAS_STAGED=0
typeset -g _GIT_ASYNC_FD=0 _GIT_ASYNC_PID=0 _GIT_ASYNC_LOCK=0
typeset -gA _GIT_REPO_CACHE
typeset -g _CURRENT_PROMPT_HOOK=""
# ── /State Variables ──────────────────────────────────────────────────

# ── Engine ────────────────────────────────────────────────────────────
# Spawns a background process that runs git status and writes results
# back to the parent shell via a file descriptor.
function _git_engine() {
    # Don't spawn if already running
    (( _GIT_ASYNC_LOCK || _GIT_ASYNC_FD )) && return

    local current_pwd="$PWD"

    # Fast exit: if we already know this dir isn't a repo
    if [[ "${_GIT_REPO_CACHE[$current_pwd]}" == "0" ]]; then
        GIT_IS_REPO=0; return
    fi

    # Kill any stale worker from a previous directory
    if (( _GIT_ASYNC_PID > 0 )); then
        kill -0 "$_GIT_ASYNC_PID" 2>/dev/null && kill -15 "$_GIT_ASYNC_PID" 2>/dev/null
    fi

    # Spawn background worker
    local fd
    exec {fd}< <(
        local branch="" modified=0 untracked=0 staged=0 is_repo=0 status_out

        if status_out=$(command git status --porcelain=v2 --branch 2>/dev/null); then
            is_repo=1
            if [[ -n "$status_out" ]]; then
                local -a lines=("${(@f)status_out}")
                for line in "${lines[@]}"; do
                    # Parse branch name
                    if [[ "$line" == "# branch.head "* ]]; then
                        branch="${line#\# branch.head }"
                        [[ "$branch" == "(detached)" ]] && branch=$(command git rev-parse --short HEAD 2>/dev/null)
                        continue
                    fi

                    # Parse file status
                    if [[ "$line" == \?* ]]; then
                        untracked=1
                    else
                        local xy_code=""
                        if [[ "$line" == 1\ * || "$line" == 2\ * ]]; then
                            local parts=("${(@s/ /)line}"); xy_code="${parts[2]}"
                        fi
                        [[ "$xy_code" == [MADRC]* ]] && staged=1
                        [[ "$xy_code" == ?[MD]* ]] && modified=1
                    fi
                done
            fi
            [[ ${#branch} -gt 20 ]] && branch="${branch[1,20]}..."
        fi

        # Send results back to parent
        print -r "$current_pwd|$is_repo|$branch|$modified|$untracked|$staged"
    )
    _GIT_ASYNC_PID=$!; _GIT_ASYNC_FD=$fd

    # Register callback for when the background process finishes
    zle -F "$fd" _git_async_callback
}
# ── /Engine ───────────────────────────────────────────────────────────

# ── Callback ──────────────────────────────────────────────────────────
# Triggered when the background worker has finished writing data.
# Parses the result and updates the global variables.
function _git_async_callback() {
    local fd=$1 content
    _GIT_ASYNC_LOCK=1

    if ! read -r content <&"$fd"; then
        zle -F "$fd"; { exec {fd}<&- ; } 2>/dev/null
        _GIT_ASYNC_FD=0; _GIT_ASYNC_LOCK=0; return
    fi

    # Clean up file descriptor
    zle -F "$fd"; { exec {fd}<&- ; } 2>/dev/null
    _GIT_ASYNC_FD=0; _GIT_ASYNC_PID=0

    # Parse: PWD|IS_REPO|BRANCH|MODIFIED|UNTRACKED|STAGED
    local -a parts=("${(@s/|/)content}")
    if (( ${#parts} >= 6 )) && [[ "${parts[1]}" == "$PWD" ]]; then
        _GIT_REPO_CACHE["${parts[1]}"]="${parts[2]}"
        GIT_IS_REPO="${parts[2]}"
        GIT_BRANCH="${parts[3]}"
        GIT_HAS_MODIFIED="${parts[4]}"
        GIT_HAS_UNTRACKED="${parts[5]}"
        GIT_HAS_STAGED="${parts[6]}"

        # Redraw prompt with new git info
        if zle 2>/dev/null; then
            [[ -n "$_CURRENT_PROMPT_HOOK" ]] && "$_CURRENT_PROMPT_HOOK" 2>/dev/null
            zle reset-prompt 2>/dev/null
        fi
    fi

    _GIT_ASYNC_LOCK=0
}
# ── /Callback ─────────────────────────────────────────────────────────

# ── Hook Manager ──────────────────────────────────────────────────────
# Ensures only one theme's hook is active at a time.
# Called by each theme during setup.
function _register_prompt_hook() {
    local hook_name="$1"
    for h in _gh0st_updater _z_updater _orbit_updater _10k_updater; do
        add-zsh-hook -d precmd $h 2>/dev/null
    done
    add-zsh-hook -d preexec _10k_record_start 2>/dev/null
    add-zsh-hook precmd "$hook_name"
    _CURRENT_PROMPT_HOOK="$hook_name"
}
# ── /Hook Manager ─────────────────────────────────────────────────────
