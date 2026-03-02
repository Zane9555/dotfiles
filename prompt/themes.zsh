# ══════════════════════════════════════════════════════════════════════
# PROMPT THEMES
# Each theme is a function that sets PS1/RPROMPT.
# They all use the async git engine from git-engine.zsh.
#
# To switch themes, change PROMPT_THEME below.
# Options: "gh0st", "z", "orbit", "10k"
# ══════════════════════════════════════════════════════════════════════

# ┌──────────────────────────────────┐
# │  CHANGE YOUR THEME HERE          │
# └──────────────────────────────────┘
PROMPT_THEME="orbit"

setopt PROMPT_SUBST

# ── Theme: gh0st ──────────────────────────────────────────────────────
# Two-tone prompt with user/host, italic path, and git branch.
# Green dot = clean, red dot = dirty.
#
# Looks like:
#    user / hostname [~/Projects/my-app]  main ● ➜
#
function theme_gh0st() {
    typeset -g _GH0ST_GIT_MSG=""

    function _gh0st_updater() {
        _git_engine
        _GH0ST_GIT_MSG=""
        if (( GIT_IS_REPO )); then
            local icon="%F{green}"
            (( GIT_HAS_MODIFIED || GIT_HAS_UNTRACKED )) && icon="%F{red}"
            _GH0ST_GIT_MSG="  %F{magenta}${GIT_BRANCH} ${icon}%{\e[0m%}"
        fi
    }

    _register_prompt_hook _gh0st_updater

    local p_user="%B%F{blue}%n"
    local p_sep="%F{red}/"
    local p_host="%F{yellow}%m"
    local p_path=$'%{\e[3m%}%F{242}[%~]%f%{\e[23m%}'
    local p_icon="%(~.%B%F{black}.%B%F{cyan})%f%b"
    local p_status="%(?.%F{green}.%F{red})➜%f"

    PS1="${p_icon} ${p_user} ${p_sep} ${p_host} ${p_path}\${_GH0ST_GIT_MSG} ${p_status} "
}
# ── /Theme: gh0st ─────────────────────────────────────────────────────

# ── Theme: z ──────────────────────────────────────────────────────────
# Minimal single-line prompt. Time on the left, git on the right.
# Colored dots show modified (red), staged (green), untracked (cyan).
#
# Looks like:
#   14:32 ➜ my-app              ( main) ●●●
#
function theme_z() {
    typeset -g GIT_RPROMPT=""

    function _z_updater() {
        _git_engine
        GIT_RPROMPT=""
        if (( GIT_IS_REPO )); then
            local dirty="" color="%F{magenta}"
            (( GIT_HAS_MODIFIED ))  && dirty+="%F{red}●"
            (( GIT_HAS_STAGED ))    && dirty+="%F{green}●"
            (( GIT_HAS_UNTRACKED )) && dirty+="%F{cyan}●"
            [[ -n "$dirty" ]] && color="%F{yellow}"
            GIT_RPROMPT=" %F{blue}(${color} ${GIT_BRANCH}%F{blue})%f ${dirty}%f"
        fi
        RPROMPT="${GIT_RPROMPT}"
    }

    _register_prompt_hook _z_updater
    PROMPT="%T %F{yellow}➜%f %F{blue}%1~%f "
}
# ── /Theme: z ─────────────────────────────────────────────────────────

# ── Theme: orbit ──────────────────────────────────────────────────────
# Two-line prompt with connecting lines. Time on the right.
# Colored dots show modified (red), staged (green), untracked (cyan).
#
# Looks like:
#   ╭── ~ ~/Projects/my-app on  main ●●         [14:32]
#   ╰─ ›
#
function theme_orbit() {
    typeset -g _ORBIT_GIT_MSG=""

    function _orbit_updater() {
        _git_engine
        _ORBIT_GIT_MSG=""
        if (( GIT_IS_REPO )); then
            local ind=""
            (( GIT_HAS_MODIFIED ))  && ind+="%F{red}●"
            (( GIT_HAS_UNTRACKED )) && ind+="%F{cyan}●"
            (( GIT_HAS_STAGED ))    && ind+="%F{green}●"
            _ORBIT_GIT_MSG=" on %F{magenta} ${GIT_BRANCH}%f ${ind}"
        fi
        RPROMPT="%F{238}[%D{%T}]%f"
    }

    _register_prompt_hook _orbit_updater
    PS1=$'\n'"%F{blue}╭──%f %F{white}%f %B%F{blue}%~%f%b\${_ORBIT_GIT_MSG}"$'\n'"%F{blue}╰─%f %B%(?.%F{green}›.%F{red}›)%f%b "
}
# ── /Theme: orbit ─────────────────────────────────────────────────────

# ── Theme: 10k ────────────────────────────────────────────────────────
# Minimal left prompt with execution timer and git on the right.
# Shows how long the last command took if > 2 seconds.
# Yellow ! if last command failed. Yellow * if background jobs.
#
# Looks like:
#   ➜                              3s [  main ●● ] ~/Projects/my-app
#
function theme_10k() {
    typeset -g _10K_START_TIME=""

    function _10k_record_start() { _10K_START_TIME=$SECONDS }

    function _10k_updater() {
        _git_engine
        local git_part="" exec_part=""

        if (( GIT_IS_REPO )); then
            local ind=""
            (( GIT_HAS_MODIFIED ))  && ind+="%F{red}●"
            (( GIT_HAS_UNTRACKED )) && ind+="%F{cyan}●"
            (( GIT_HAS_STAGED ))    && ind+="%F{green}●"
            git_part="[ %F{magenta} ${GIT_BRANCH}%f ${ind}%f ] "
        fi

        if [[ -n "$_10K_START_TIME" ]]; then
            local delta=$(($SECONDS - _10K_START_TIME))
            (( delta > 2 )) && exec_part="%F{cyan}${delta}s%f "
            unset _10K_START_TIME
        fi

        RPROMPT="${exec_part}${git_part}%F{blue}%~%f"
    }

    _register_prompt_hook _10k_updater
    add-zsh-hook preexec _10k_record_start
    PS1="%F{green}${SSH_TTY:+%n@%m}%f%F{yellow}%B%(1j.*.)%(?..!)%b%f %B%(?.%F{green}.%F{red})➜%f%b "
}
# ── /Theme: 10k ───────────────────────────────────────────────────────

# ── Theme Selection ───────────────────────────────────────────────────
case "${PROMPT_THEME:l}" in
    gh0st) theme_gh0st ;;
    z)     theme_z     ;;
    orbit) theme_orbit ;;
    10k)   theme_10k   ;;
    *)     theme_gh0st ;; # fallback
esac
# ── /Theme Selection ──────────────────────────────────────────────────
