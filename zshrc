# ╔══════════════════════════════════════════════════════════════════════╗
# ║  Main Zsh Configuration                                            ║
# ║  This file just sources everything else.                           ║
# ║  Comment out a line to disable that feature.                       ║
# ╚══════════════════════════════════════════════════════════════════════╝

# Where this repo lives on disk
export DOTFILES_DIR="$HOME/dotfiles"

# ── Local (must load first — PATH needed by everything below) ────────
source "$DOTFILES_DIR/local/path.zsh"

# ── Core (order matters) ──────────────────────────────────────────────
source "$DOTFILES_DIR/core/options.zsh"
source "$DOTFILES_DIR/core/history.zsh"
source "$DOTFILES_DIR/core/completion.zsh"
source "$DOTFILES_DIR/core/eval-cache.zsh"
source "$DOTFILES_DIR/core/keybinds.zsh"

# ── Engine ────────────────────────────────────────────────────────────
source "$DOTFILES_DIR/engine/defer/defer.zsh"
source "$DOTFILES_DIR/engine/plugin-manager/plugin-manager.zsh"

# ── Prompt ────────────────────────────────────────────────────────────
source "$DOTFILES_DIR/prompt/git-engine.zsh"
source "$DOTFILES_DIR/prompt/themes.zsh"

# ── Plugins ───────────────────────────────────────────────────────────
source "$DOTFILES_DIR/plugins/fzf/fzf.zsh"
source "$DOTFILES_DIR/plugins/fzf/fzf-tab.zsh"
source "$DOTFILES_DIR/plugins/zoxide/zoxide.zsh"
source "$DOTFILES_DIR/plugins/aliases/aliases.zsh"


# ── Local (personal config) ──────────────────────────────────────────
source "$DOTFILES_DIR/local/aliases.zsh"
