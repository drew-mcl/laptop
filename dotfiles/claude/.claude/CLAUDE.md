# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) across all repositories.

## Claude Code Workflow

### How sessions start

Sessions are started from the shell with `clc`, which runs `claude --dangerously-skip-permissions --worktree` inside a git repo. That means:

- **You are usually already in a worktree** at `<repo>/.claude/worktrees/<name>` on branch `worktree-<name>`. Do not create another one unless asked to parallelize.
- `clm` is the exception: it runs in the main checkout for quick edits and repo-wide chores.
- Worktree cleanup happens on exit (Claude prompts to keep or remove). Do not delete worktrees yourself.

If a session was started with plain `claude` (no worktree) and the work is a feature or significant change, ask to move into a worktree or create one with `git worktree add`.

### Feature Development

**Always use the `/feature-dev` skill** for new features or significant changes when it is available. This ensures proper planning, architecture review, and implementation.

### Git Worktrees (manual)

When a session is not already isolated:

```bash
# Create worktree for a feature
git worktree add ../repo-feature-name -b feature-name

# Or with Linear issue
git worktree add ../repo-eng-123 -b drew/eng-123-feature-name

# List worktrees (or the shell function `gwt`)
git worktree list

# Remove worktree when done (after merge)
git worktree remove ../repo-feature-name
```

**On completion**: Always clean up manual worktrees after PR is merged. Use `git worktree remove <path>` or `git worktree prune` for stale entries.

### Linear Integration

**PR/MR titles**: Include Linear issue ID in the title
```
ENG-123: feat(auth): add OAuth2 login flow
```

**PR/MR descriptions**: Use magic words to auto-link and close issues
```
Fixes ENG-123

## Summary
...
```

**Magic words** (trigger auto-close on merge): `close`, `closes`, `fix`, `fixes`, `resolve`, `resolves`, `complete`, `completes`

**Non-closing words** (link without auto-close): `ref`, `references`, `part of`, `related to`, `contributes to`

**Branch naming**: Use Linear's branch format: `username/eng-123-short-description`

### Commit Format

When Linear issues are used:
```
ENG-123: feat(scope): description

Body with details...
```

Without Linear:
```
feat(scope): description
```

**Never include co-authored-by lines.**

## Claude Code Setup

Global config lives in `~/repos/macos/dotfiles/claude/.claude/` and is stowed to `~/.claude/`. Edit the repo copy (`ws claude settings|status|hooks`), never the symlink.

| File | Purpose |
|------|---------|
| `settings.json` | Model (`claude-fable-5-1[1m]`), effort, enabled plugins, fullscreen TUI, status line, hooks |
| `statusline.sh` | Model, project, worktree, branch, context bar, cost, rate limits |
| `hooks/notify.sh` | macOS notification on `permission_prompt`, `idle_prompt`, `agent_needs_input` when the terminal is not frontmost |

### Enabled Plugins

| Plugin | Purpose |
|--------|---------|
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` |
| `code-review` | `/code-review` for PRs and diffs |
| `code-simplifier` | `/simplify` refactoring and cleanup |
| `frontend-design` | UI/frontend development guidance |
| `security-guidance` | Security best practices and workflow-file warnings |
| `context7` | Up-to-date library documentation |
| `playwright` | Browser automation and testing |
| `github` | GitHub MCP server |
| `typescript-lsp`, `pyright-lsp` | Language servers for TypeScript and Python |

### MCP Servers

- **Linear**: Issue tracking, project management
- **Sentry**: Error monitoring, issue analysis
- **Supabase**: Database queries, auth management
- **Playwright**: Browser automation
- **Context7**: Library documentation lookup

### Skills

| Skill | Description |
|-------|-------------|
| `/feature-dev` | Start guided feature development (when installed) |
| `/commit` | Create git commit |
| `/commit-push-pr` | Commit, push, and open PR |
| `/code-review` | Review a pull request or the current diff |
| `/simplify` | Clean up recently changed code |

## System Config Sync

When modifying system configuration as part of development work, ensure changes are
tracked in the macos repo for repeatability:

**What to sync (via `ws sync` or manual commit):**
- Brew packages added/removed - update the relevant Brewfile (`ws doctor` shows drift both ways)
- Runtime versions changed - update mise config.toml
- Shell aliases or functions added - update .zshrc and docs/shell.md
- New tools installed - update Brewfile.base and docs/cli-tools.md
- Environment variables added - update .zshenv
- Claude Code settings, hooks, or status line changed - update dotfiles/claude

**After making changes:**
1. Edit the source file in ~/repos/macos (not the symlinked target)
2. Run `ws stow` to re-symlink
3. Run `ws sync` to commit and push to main

Never modify symlinked config files directly - always edit the source in the repo.

## Available CLI Tools

Full list with links in `~/repos/macos/docs/cli-tools.md`.

### Git & Version Control

| Tool | Description |
|------|-------------|
| `git` | Version control |
| `git-delta` | Better git diff viewer |
| `git-cliff` | Changelog generator |
| `gh` | GitHub CLI |
| `glab` | GitLab CLI |
| `lazygit` | Terminal UI for git |

### Search & Navigation

| Tool | Description |
|------|-------------|
| `ripgrep` (`rg`) | Fast grep replacement |
| `fd` | Fast find replacement |
| `fzf` | Fuzzy finder |
| `zoxide` (`z`) | Smarter cd with frecency |
| `yazi` (`y`) | Terminal file manager |
| `tree` | Directory tree viewer |

### File Viewing & Editing

| Tool | Description |
|------|-------------|
| `bat` | cat with syntax highlighting |
| `eza` | Modern ls replacement |
| `neovim` (`nvim`) | Modern vim (LazyVim) |

### System Monitoring

| Tool | Description |
|------|-------------|
| `bottom` (`btm`) | Better top/htop |
| `procs` | Better ps |
| `dust` | Better du (disk usage) |

### Development

| Tool | Description |
|------|-------------|
| `mise` | Runtime version manager (ruby, node, python, go, rust) |
| `direnv` | Per-directory environment variables |
| `jq` | JSON processor |
| `httpie` / `xh` | Better curl for APIs |
| `hyperfine` | CLI benchmarking |
| `tokei` | Code statistics |
| `actionlint` | GitHub Actions linter |
| `shellcheck` | Shell script linter |
| `yarn` / `nx` | JS workspace tooling |

### Mobile

| Tool | Description |
|------|-------------|
| `cocoapods` | iOS dependency manager |
| `asc` | App Store Connect CLI |
| `greenlight` | App Store / Play pre-submission scanner |
| `maestro` | Mobile E2E testing |

### Infrastructure

| Tool | Description |
|------|-------------|
| `kubectl` | Kubernetes CLI |
| `helm` | Kubernetes package manager |
| `terraform` | Infrastructure as code |
| `lazydocker` | Docker TUI |
| `ansible` | Automation/config management |
| `supabase` | Supabase CLI |
| `gcloud` | Google Cloud CLI |

### Utilities

| Tool | Description |
|------|-------------|
| `stow` | Symlink farm manager |
| `tlrc` (`tldr`) | Command examples |
| `watchman` | File watcher |
| `atuin` | Shell history with sync (Ctrl+R) |
| `starship` | Cross-shell prompt |
| `entire` | Claude Code session checkpoints |

## Shell Aliases

### Claude Code

| Command | Description |
|---------|-------------|
| `clc [name]` | Claude, permissions skipped, in a fresh worktree of the current repo |
| `clm` | Claude in the main checkout (no worktree) |
| `clr` | Resume picker |
| `clcc` | Continue most recent session here |
| `zc <repo>` | `z <repo>` then `clc` |

### Git

| Alias | Expansion |
|-------|-----------|
| `gs` | `git status -sb` |
| `gco [branch]` | `git checkout`; no args opens an fzf branch picker |
| `gb` | `git branch -vv --sort=-committerdate` |
| `gl` / `gla` | `git log --oneline --graph --decorate` (-20 / --all -30) |
| `gd` / `gds` | `git diff` / `git diff --staged` |
| `gp` | `git pull --ff-only && git push` |
| `gpm` | `git prep-merge` (interactive rebase onto default) |
| `gpm1` | `git prep-merge-squash` (squash to one commit) |
| `gwt` | List worktrees with branch, age, dirty count |

### GitLab

| Alias | Description |
|-------|-------------|
| `gmr` | Create MR with `--fill --remove-source-branch` |
| `gml` | List MRs assigned to me |
| `gms` | MR status |
| `gci` | View CI pipeline |
| `gmco` | FZF picker to checkout an open MR |

### Modern Replacements

| Alias | Actual Command |
|-------|----------------|
| `cat` | `bat --paging=never` |
| `less` | `bat` |
| `du` | `dust` |
| `ps` | `procs` |
| `top`/`htop` | `btm` |
| `vim`/`vi` | `nvim` |
| `ll` | `eza -lah --git` |
| `lt` | `eza --tree --level=2` |

### Ruby

| Alias | Description |
|-------|-------------|
| `be` | `bundle exec` |

## Shell Functions

| Function | Description |
|----------|-------------|
| `m [target]` | Run make from nearest parent Makefile |
| `mt` | FZF picker for make targets |
| `y` | Yazi file manager (cd on exit) |
| `z <dir>` | Zoxide smart cd |
| `sshx` | FZF SSH host picker from config |
| `ssh-host <host>` | Generate per-host SSH key + config |
| `repo` | FZF browse local, GitHub, and GitLab repos; cd or clone |
| `aa` | FZF alias browser |
| `envim` | Open nearest .env file in nvim |
| `ws <cmd>` | Workstation config manager |
| `obsidian-sync` | Git sync Obsidian vault |

## Development Workflows

### Rails Applications

```bash
bin/setup              # Install dependencies, prepare database, start server
bin/dev                # Start Rails + asset watchers (via Foreman)
bin/rails test         # Run all tests
bin/ci                 # Run full CI suite
bin/rubocop            # Ruby style linter
bin/kamal deploy       # Deploy via Kamal
```

### Ruby Conventions

- **Framework**: Minitest with `ActiveSupport::TestCase`
- **Fixtures**: Located in `test/fixtures/`
- **File structure**: Mirror app in tests (`app/models/user.rb` → `test/models/user_test.rb`)

### Common Patterns

**ViewComponent**
- Components in `app/components/`
- In `.rb`: Call helpers directly
- In `.html.erb`: Use `helpers.` prefix

**Multi-Database Rails**
- Primary: PostgreSQL
- Solid adapters: SQLite for Cache/Queue/Cable

### Design Guidelines

- **No emojis in code** - Use icon helpers
- **Keep code idempotent** - Safe to re-run

## README Style

Root READMEs should be minimal and scannable. This does not apply to docs/ pages which can be more detailed.

- **lowercase titles** — `# macos` not `# macOS Setup`
- **short, punchy copy** — one-liners over paragraphs, let the tools speak for themselves
- **code blocks over prose** — show commands, not explanations of commands
- **no feature lists or badges** — don't enumerate what's inside, just show how to use it
- **real emoji** — use ❤️ not `<3`, but sparingly
- **no section bloat** — if it can be a one-liner, it should be
- **link to docs/ for detail** — keep the README as a landing page, not a manual

Reference: the `macos` README.md is the canonical example of this style.

## Task Tracking

**Always use Task tools** (TaskCreate, TaskUpdate, TaskList) instead of TodoWrite for tracking work items. The Task tools provide better progress visibility and persist across sessions.

Environment variable required in shell profile (set in `.zshenv`):
```bash
export CLAUDE_CODE_ENABLE_TASKS=true
```
