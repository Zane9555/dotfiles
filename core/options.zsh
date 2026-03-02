# ══════════════════════════════════════════════════════════════════════
# OPTIONS
# Shell behavior settings. These are all just setopt/unsetopt lines.
# Safe to add/remove — they only change how zsh behaves interactively.
# ══════════════════════════════════════════════════════════════════════

# ── Navigation ────────────────────────────────────────────────────────
setopt AUTO_CD              # Type a directory name to cd into it
setopt AUTO_PUSHD           # cd pushes to directory stack
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt PUSHD_SILENT         # Don't print stack after pushd/popd
# ── /Navigation ───────────────────────────────────────────────────────

# ── Completion Behavior ───────────────────────────────────────────────
setopt COMPLETE_IN_WORD     # Complete from cursor position, not just end
setopt GLOB_COMPLETE        # Show menu for glob completions
setopt EXTENDED_GLOB        # Advanced pattern matching (#, ~, ^)
setopt GLOB_DOTS            # Tab-complete hidden files without typing the dot
setopt ALWAYS_TO_END        # Move cursor to end after completing
# ── /Completion Behavior ──────────────────────────────────────────────

# ── Misc ──────────────────────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS  # Allow # comments in terminal
setopt NOBEEP                # No error beeps
setopt NOTIFY                # Report background job status immediately

unsetopt FLOWCONTROL         # Disable Ctrl+S/Ctrl+Q freezing
unsetopt NOMATCH             # Don't error on failed globs, pass them through
# ── /Misc ─────────────────────────────────────────────────────────────
