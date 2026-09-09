# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS laptop setup repository using GNU Stow for dotfile management and Make for orchestration. It provisions development tools via Homebrew, installs Claude Code via its native installer, manages language runtimes via mise, and symlinks dotfiles to `$HOME`. Visual theme is Catppuccin Frappe across all tools. The shell is built around Claude Code as the primary way work gets done (`clc` and friends).

## Common Commands

```bash
make bootstrap        # Full setup: git, ssh, brew, claude, github, dirs, stow, oh-my-zsh, mise, macos
make stow             # Restow all dotfiles after changes (also installs yazi flavor)
make stow-clean       # Backup conflicts to ~/.local/share/macos/backups/, then restow
make doctor           # Print versions for installed tools
make brew             # Install all Homebrew packages (base + apps)
make claude-install   # Install Claude Code (native installer) if missing
make mise-install     # Install language runtimes from mise config
make setup-git        # Configure git identity
make setup-ssh        # Generate SSH key and configure agent
make install-brew     # Install Homebrew if not present
make macos            # Apply macOS defaults
make unstow           # Remove all symlinks
make nuke             # Full reset: unstow, remove oh-my-zsh, re-bootstrap
make help             # Show all available targets (default)
```

## The `ws` Command

A shell function for managing workstation config:

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
ws claude    # Edit global CLAUDE.md; ws claude settings|status|hooks
ws edit      # FZF picker for any config file
ws sync      # Commit + push changes
ws stow      # Re-stow all packages
ws doctor    # Drift check: brew (both directions), mise, stow, Claude Code
ws update    # Brew update + restow
ws profile   # Shell startup time profiling
```

## Architecture

### Dotfiles Structure

Each folder in `dotfiles/` is a GNU Stow package. Running `stow <package>` symlinks its contents to `$HOME`. The `--no-folding` flag ensures individual files are symlinked rather than entire directories.

Current stow packages: `curl git gh glab ghostty mise ruby ssh zsh direnv starship yazi atuin nvim claude lazygit bottom`

### Claude Code Config (`dotfiles/claude`)

Stowed to `~/.claude/`:

- `CLAUDE.md` - global dev workflows (Rails conventions, git workflow, testing patterns)
- `settings.json` - model, effort, enabled plugins, fullscreen TUI, status line, hooks
- `statusline.sh` - status line (model, project, worktree, branch, context bar, cost, rate limits), Frappe colors
- `hooks/notify.sh` - macOS notification when Claude needs input and the terminal is not frontmost

Claude Code itself is installed with the native installer (`make claude-install`), not Homebrew, so it self-updates. Never add a `claude-code` cask.

### Brewfiles

- `brew/Brewfile.base` - CLI tools grouped by purpose (shell, git, files, monitoring, dev, mobile, cloud, AI agents, build deps), plus taps
- `brew/Brewfile.apps` - GUI applications, cask-distributed CLIs (entire, gcloud-cli), fonts

`ws doctor` reports drift in both directions: Brewfile entries not installed, and installed leaves/casks not in a Brewfile.

### Scripts

Helper scripts in `scripts/` are invoked by Make targets:
- `ssh-host.sh` - Generate per-host SSH keys with config.d entries (also the `ssh-host` shell function)
- `macos-defaults.sh` / `macos-dock.sh` - Apply macOS system preferences and Dock layout
- `dirs.sh` - Create ~/repos, ~/repos/worktrees, ~/.local/bin
- `install-oh-my-zsh.sh`, `run-custom.sh`, `git-monorepo.sh`

### Shell Configuration

`dotfiles/zsh/.zshrc`:
1. Initializes Homebrew and PATH
2. Sets the Catppuccin Frappe palette (BAT_THEME, FZF_DEFAULT_OPTS)
3. Caches generated completions (Entire) into `~/.cache/zsh/completions` before oh-my-zsh runs its single `compinit`
4. Loads oh-my-zsh (git, fzf plugins), autosuggestions, syntax highlighting
5. Activates mise, direnv, gcloud, zoxide, atuin, starship
6. Defines aliases and functions: modern CLI replacements, git (`gco` fzf picker, `gwt`), Claude Code (`clc`, `clm`, `clr`, `clcc`, `zc`), helpers, `ws`, `obsidian-sync`
7. Prints one tip from `~/.config/zsh/tips.txt` (suppressed when `$CLAUDECODE` is set) and cds to `~/repos` only when opened in `$HOME`

`dotfiles/zsh/.zshenv` holds Keychain secret helpers, EDITOR, `MACOS_SETUP`, and Claude Code env vars.

### Theme: Catppuccin Frappe

Applied consistently across: Ghostty, Neovim, bat, fzf, git-delta, lazygit, bottom, Yazi, Claude Code status line. See `docs/catppuccin.md` for the palette and how each tool is wired.

## Conventions

- Commits follow conventional commits: `feat(scope):`, `fix(scope):`, `refactor(scope):`
- Scripts should be idempotent - safe to re-run
- Custom per-machine scripts go in `custom/` and run via `make custom`
- Stow package additions require updating `STOW_PACKAGES` in the Makefile
- Always edit source files in this repo, never the symlinked targets
- Yazi config uses `prepend_keymap` / `prepend_rules` on top of the preset; do not copy the full preset in
- CI (`.github/workflows/validate.yml`) runs shellcheck, `zsh -n`, Brewfile parsing, JSON/TOML parsing, and a stow dry-run
