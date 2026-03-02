# ══════════════════════════════════════════════════════════════════════
# CARAPACE — Universal Command Completion Engine
# Provides tab completions for 500+ CLI tools automatically.
# If a tool doesn't ship its own zsh completions, carapace fills the gap.
#
# Works with fzf-tab — carapace provides the completion data,
# fzf-tab renders it as a fuzzy-searchable menu.
#
# Bridge mode pulls completions from fish/bash/inshellisense too,
# so you get completions even for obscure tools.
#
# Requires: brew install carapace
# ══════════════════════════════════════════════════════════════════════

# Bail if carapace isn't installed
(( $+commands[carapace] )) || return

# ── Bridge Mode ───────────────────────────────────────────────────────
# Pull completions from other shells when carapace doesn't have
# a native completer for a command. Tries zsh first, then fish,
# then bash, then inshellisense.
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
# ── /Bridge Mode ──────────────────────────────────────────────────────

# ── Completion Formatting ─────────────────────────────────────────────
# Group header style for fzf-tab compatibility
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
# ── /Completion Formatting ────────────────────────────────────────────

# ── Load Carapace ─────────────────────────────────────────────────────
# Registers completions for all supported commands at once.
# This must come AFTER compinit and AFTER fzf-tab is loaded.
source <(carapace _carapace)
# ── /Load Carapace ────────────────────────────────────────────────────
