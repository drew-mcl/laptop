# Shell Reference

Complete reference for shell aliases, functions, and the `ws` command.

## Claude Code

Almost all dev work runs through Claude Code, so the shell is built around it.

| Command | Description |
|---------|-------------|
| `clc [name]` | Start Claude with permissions skipped. Inside a git repo it creates a worktree at `.claude/worktrees/<name>` (auto-named if omitted) so parallel sessions never collide. Outside a repo, or already inside a Claude worktree, it runs in place. `clc "#123"` branches from PR/MR 123. |
| `clm` | Claude in the main checkout, no worktree. For quick edits and repo-wide chores. |
| `clr` | Resume picker. Resumed sessions return to their worktree. |
| `clcc` | Continue the most recent session in this directory. |
| `zc <repo>` | `z <repo>` then `clc`. |
| `gwt` | List this repo's worktrees with branch, age, and dirty count. |

On exit, Claude prompts to keep or remove the worktree if it has work in it; clean unnamed worktrees are removed automatically. Add a `.worktreeinclude` file to a repo to copy gitignored files such as `.env` into every new worktree.

Claude Code config is stowed from `dotfiles/claude/.claude/`:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions loaded into every session |
| `settings.json` | Model, effort, plugins, status line, hooks |
| `statusline.sh` | Status line: model, project, worktree, branch, context bar, cost, rate limits |
| `hooks/notify.sh` | macOS notification when Claude needs input and the terminal is not frontmost |

Edit with `ws claude [md|settings|status|hooks]`.

## The `ws` Command

Workstation config manager. Quick access to edit, sync, and diagnose your setup.

```bash
ws brew      # Edit Brewfiles
ws zsh       # Edit .zshrc
ws env       # Edit .zshenv
ws git       # Edit .gitconfig
ws ghostty   # Edit Ghostty config
ws nvim      # Edit Neovim config
ws mise      # Edit mise runtime versions
ws star      # Edit Starship prompt
ws ssh       # Edit SSH config
ws tips      # Edit terminal tips
ws claude    # Edit CLAUDE.md; ws claude settings|status|hooks for the rest
ws edit      # FZF picker for any config file
ws sync      # Commit + push changes
ws stow      # Re-stow all packages
ws doctor    # Drift check: brew (both directions), mise, stow, Claude Code
ws update    # Brew update + restow
ws profile   # Shell startup time + slowest init functions
```

Tab completion is enabled for all `ws` subcommands.

## Tip of the Shell

Every new terminal prints one random line from `~/.config/zsh/tips.txt` (stowed from `dotfiles/zsh/.config/zsh/tips.txt`). It is suppressed inside Claude Code shells. Add your own with `ws tips`.

## Git Aliases

| Alias | Expansion |
|-------|-----------|
| `gs` | `git status -sb` |
| `gco [branch]` | `git checkout`; with no args, fzf over local + remote branches sorted by recent commit |
| `gb` | `git branch -vv --sort=-committerdate` |
| `gl` | `git log --oneline --graph --decorate -20` |
| `gla` | Same, `--all -30` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gp` | `git pull --ff-only && git push` |
| `gpm` | `git prep-merge` (interactive rebase onto default branch) |
| `gpm1` | `git prep-merge-squash` (squash all commits to one) |
| `git wt` / `git wtp` | `worktree list` / `worktree prune` |

## GitLab Aliases

| Alias | Description |
|-------|-------------|
| `gmr` | Create MR with `--fill --remove-source-branch` |
| `gml` | List MRs assigned to me |
| `gms` | MR status |
| `gci` | View CI pipeline |
| `gmco` | FZF picker to checkout an open MR |

## Modern CLI Aliases

| Alias | Actual Command |
|-------|----------------|
| `cat` | `bat --paging=never` |
| `less` | `bat` |
| `du` | `dust` |
| `ps` | `procs` |
| `top` / `htop` | `btm` (Frappe theme via `~/.config/bottom/bottom.toml`) |
| `vim` / `vi` | `nvim` |
| `ll` | `eza -lah --git --group-directories-first` |
| `lt` | `eza --tree --level=2` |
| `be` | `bundle exec` |

## Shell Functions

| Function | Description |
|----------|-------------|
| `m [target]` | Run make from nearest parent Makefile |
| `mt` | FZF picker for make targets |
| `y` | Yazi file manager (cd on exit) |
| `z <dir>` | Zoxide smart cd (frecency-based) |
| `sshx` | FZF SSH host picker from config |
| `ssh-host <host>` | Generate per-host SSH key + config |
| `repo` | FZF over local `~/repos`, GitHub, and GitLab repos; cd or clone |
| `aa` | FZF alias browser |
| `envim` | Open nearest .env file in nvim |
| `obsidian-sync` | Git commit + push Obsidian vault |

## Key Environment Variables

Set in `.zshenv`:

| Variable | Default | Description |
|----------|---------|-------------|
| `MACOS_SETUP` | `~/repos/macos` | Path to this repo |
| `OBSIDIAN_VAULT` | `~/Documents/Obsidian` | Path to Obsidian vault |
| `CLAUDE_CODE_ENABLE_TASKS` | `true` | Enable Claude Code task tracking |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | `1` | Enable Claude Code agent teams |
| `BAT_THEME` | `Catppuccin Frappe` | bat/cat syntax theme (set in `.zshrc`) |
| `FZF_DEFAULT_OPTS` | (Frappe colors) | FZF appearance (set in `.zshrc`) |

## Startup Behavior

- Completions generated by tools (currently Entire) are cached in `~/.cache/zsh/completions` and picked up by oh-my-zsh's single `compinit`.
- A new shell opened in `$HOME` moves to `~/repos`. Shells opened anywhere else (new Ghostty tab from a repo) stay put.
- Startup is around 0.2s; check with `ws profile`.

## Keychain Secrets

Secrets are managed via macOS Keychain helpers in `.zshenv`:

```bash
keychain-set VAR_NAME "value"   # Store a secret
keychain-get VAR_NAME           # Retrieve a secret
keychain-rm VAR_NAME            # Remove a secret
keychain-list                   # List all stored secrets
```

Secrets defined in `_KEYCHAIN_SECRETS` array are auto-loaded on shell start.
