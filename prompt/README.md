# Prompt

Async git-aware prompt with multiple themes.

## How to change your theme

Edit `PROMPT_THEME` at the top of `themes.zsh`:

```zsh
PROMPT_THEME="gh0st"    # options: gh0st, z, orbit, 10k
```

Then reload: `exec zsh`

## Themes

### gh0st
Two-tone prompt with user/host, italic path, and git branch. Green dot = clean, red dot = dirty.
```
 user / hostname [~/Projects/my-app]  main ● ➜
```

### z
Minimal single-line. Time on the left, git info on the right. Colored dots for modified/staged/untracked.
```
14:32 ➜ my-app                        ( main) ●●●
```

### orbit
Two-line prompt with connecting lines. Git on line 1, cursor on line 2.
```
╭──  ~/Projects/my-app on  main ●●         [14:32]
╰─ ›
```

### 10k
Minimal left side, rich right side. Shows command execution time if > 2 seconds.
```
➜                              3s [  main ●● ] ~/Projects/my-app
```

## Files

| File | What it does |
|------|--------------|
| `git-engine.zsh` | Background git status fetcher. Don't edit. |
| `themes.zsh` | Theme definitions + theme selection. Edit this. |

## How the async git engine works

Instead of running `git status` synchronously (which blocks your typing in large repos), the engine spawns a background process. When it finishes, it writes the results back via a file descriptor and the prompt redraws automatically. You never notice it happening.
