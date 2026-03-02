# ══════════════════════════════════════════════════════════════════════
# KEYBINDS
# Detects correct key codes from your terminal via terminfo,
# falls back to standard ANSI codes if terminfo is missing.
# Fixes garbage characters (^[[A etc.) in some terminals.
# Adds smart history search: type something then Up arrow filters history.
# ══════════════════════════════════════════════════════════════════════

zmodload zsh/terminfo
zmodload zsh/complist

# Smart history search: type "git" then Up arrow only shows git commands
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

# ── Key Code Detection ────────────────────────────────────────────────
# Terminfo with ANSI fallbacks
typeset -gA key_map
key_map[Up]="${terminfo[kcuu1]:-^[[A}"
key_map[Down]="${terminfo[kcud1]:-^[[B}"
key_map[Left]="${terminfo[kcub1]:-^[[D}"
key_map[Right]="${terminfo[kcuf1]:-^[[C}"
key_map[Home]="${terminfo[khome]:-^[[H}"
key_map[End]="${terminfo[kend]:-^[[F}"
key_map[Delete]="${terminfo[kdch1]:-^[[3~}"
key_map[BackTab]="${terminfo[kcbt]:-^[[Z}"
key_map[Ctrl-Left]="${terminfo[kLFT5]:-^[[1;5D}"
key_map[Ctrl-Right]="${terminfo[kRIT5]:-^[[1;5C}"
# ── /Key Code Detection ───────────────────────────────────────────────

# ── Standard Editing ──────────────────────────────────────────────────
bindkey "^?" backward-delete-char       # Backspace
bindkey "^H" backward-delete-char       # Ctrl+H (alternate backspace)
bindkey "^U" backward-kill-line         # Ctrl+U: clear line left of cursor
bindkey "^K" kill-line                  # Ctrl+K: clear line right of cursor
bindkey "^W" backward-kill-word         # Ctrl+W: delete previous word
bindkey " "  magic-space                # Space: expand history (!! etc.)
bindkey '^I' complete-word              # Tab: trigger completion
# ── /Standard Editing ─────────────────────────────────────────────────

# ── Arrow Keys ────────────────────────────────────────────────────────
[[ -n "${key_map[Left]}" ]]       && bindkey -- "${key_map[Left]}"       backward-char
[[ -n "${key_map[Right]}" ]]      && bindkey -- "${key_map[Right]}"      forward-char
# ── /Arrow Keys ───────────────────────────────────────────────────────

# ── Word Jumping (Ctrl+Arrow) ────────────────────────────────────────
[[ -n "${key_map[Ctrl-Left]}" ]]  && bindkey -- "${key_map[Ctrl-Left]}"  backward-word
[[ -n "${key_map[Ctrl-Right]}" ]] && bindkey -- "${key_map[Ctrl-Right]}" forward-word
# ── /Word Jumping ─────────────────────────────────────────────────────

# ── Home / End / Delete ───────────────────────────────────────────────
[[ -n "${key_map[Home]}" ]]       && bindkey -- "${key_map[Home]}"       beginning-of-line
[[ -n "${key_map[End]}" ]]        && bindkey -- "${key_map[End]}"        end-of-line
[[ -n "${key_map[Delete]}" ]]     && bindkey -- "${key_map[Delete]}"     delete-char
# ── /Home / End / Delete ──────────────────────────────────────────────

# ── Completion Menu ───────────────────────────────────────────────────
# Shift+Tab: reverse cycle through completion menu
[[ -n "${key_map[BackTab]}" ]]    && bindkey -- "${key_map[BackTab]}"    reverse-menu-complete
# ── /Completion Menu ──────────────────────────────────────────────────

# ── Smart History Search ──────────────────────────────────────────────
# Up/Down filtered by what you've already typed
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
[[ -n "${key_map[Up]}" ]]   && bindkey -- "${key_map[Up]}"   up-line-or-beginning-search
[[ -n "${key_map[Down]}" ]] && bindkey -- "${key_map[Down]}" down-line-or-beginning-search
# ── /Smart History Search ─────────────────────────────────────────────

# ── Editor ────────────────────────────────────────────────────────────
# Ctrl+E: open current command in $EDITOR
bindkey '^e' edit-command-line
# ── /Editor ───────────────────────────────────────────────────────────
