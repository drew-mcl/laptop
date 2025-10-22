# Laptop Setup & Dotfiles

Opinionated, idempotent laptop setup with GNU Stow–managed dotfiles and a Makefile-driven workflow. Targets macOS with Homebrew, but keeps pieces modular.

Highlights
- Dotfiles for: curl, git, glab, ghostty, gradle, mise, ruby, ssh, vscode, zsh (oh-my-zsh + Starship)
- Codex CLI install + auto-update via `pipx`
- Nerd Font packages (JetBrains Mono + symbols) so Starship icons render correctly in Ghostty/VS Code
- Pre‑brew bootstrap to configure git/curl before using Homebrew (corp-friendly)
- Brew-managed CLI tools and apps (terraform, consul, Ghostty, Obsidian, IntelliJ, VS Code, Oracle JDKs, draw.io)
- Mise-managed language runtimes with sensible defaults (Ruby, Node, Python, Go, Rust)
- SSH key setup helper and sensible SSH defaults
- Dev directories bootstrap (repos/...)
- Custom hooks for per‑laptop/internal tooling
 - GitLab CLI (glab) with helpful aliases

Quick Start
1) Ensure Homebrew is installed with your internal tooling. Optionally copy `.env.example` to `.env` and fill in git identity defaults.
2) Run `make bootstrap` to perform pre-brew setup, install the Brew bundles, restow dotfiles, install oh-my-zsh, Codex CLI, VS Code dependencies, and provision mise runtimes.
3) After changing dotfiles, run `make stow` to restow symlinks (if it reports conflicts, use `make stow-clean` to back up and overwrite).
4) Extras: `make ssh` sets up SSH keys; `make macos` applies optional macOS tweaks.

Make Targets
Primary:
- `bootstrap`: Full setup—pre-brew config, brew bundles, oh-my-zsh, VS Code, and `mise install`.
- `stow`: Restow every dotfile package into `$HOME`.

Advanced:
- `bootstrap-prebrew`: Configure git/curl before using brew; create dev dirs.
- `brew-core`: Install core CLI (stow, git-delta, jq, ripgrep, etc.).
- `brew-dev`: Install dev tools/apps (terraform, consul, Ghostty, Obsidian, IntelliJ, VS Code, Oracle JDKs, draw.io) and ensure `.app` bundles are linked into your Applications folder.
- `brew-all`: Core + Dev.
- `oh-my-zsh`: Install oh-my-zsh without changing your shell automatically.
- `codex`: Install or upgrade the Codex CLI via `pipx` (`CODEX_PACKAGE` overrides the package name, default `codex-cli`).
- `mise-install`: Install the default runtimes declared in `dotfiles/mise/.config/mise/config.toml`.
- `stow-clean`: Move conflicting files into `~/.local/share/laptop-setup/backups/<timestamp>/` and restow packages.
- `ssh`: Generate ed25519 key, add to agent, print pubkey.
- `macos`: Apply opinionated macOS defaults (safe/standard tweaks).
- `custom`: Run optional custom scripts for other laptops.
 - `install`: Legacy alias for brew-all + stow + oh-my-zsh + vscode + mise-install.
 - `refresh`: Update brew packages and restow.
 - `vscode`: Install the curated extensions list.
 - `git-monorepo REPO=/path`: Apply repo-local performance tuning for huge repos.
- `unstow`: Remove symlinks for all stow packages.
- `nuke`: Confirm, then unstow, wipe `~/.oh-my-zsh`, and rerun a full bootstrap using `stow-clean`.

Language Runtimes
- `mise` drives global versions. Defaults live in `dotfiles/mise/.config/mise/config.toml` (Ruby 3.3, Node LTS, Python 3.12, Go 1.22, Rust stable, Ansible Core 2.15.3).
- Ruby ergonomics: `.gemrc`, `.default-gems`, `.bundle/config`, and `.irbrc` live in `dotfiles/ruby/`.
- Brewfiles:
- `brew/Brewfile.base` for core CLI/tooling (adds ansible-core, kubectl, helm, mise, starship, pipx, dockutil).
  - `brew/Brewfile.langs` for HashiCorp CLIs and Oracle JDK casks (terraform, consul, JDK).
  - `brew/Brewfile.apps` for GUI apps and Nerd Fonts (JetBrains Mono + Symbols-only) to satisfy Starship glyphs (no extra tap required).

Stow Packages
- `curl`, `git`, `glab`, `ghostty`, `gradle`, `mise`, `ruby`, `ssh`, `vscode`, `zsh` (each a folder in `dotfiles/`).

Customizations
- Put laptop/company‑specific steps in `custom/` and invoke with `make custom`.

Safety & Re-runs
- Scripts are idempotent. Re-run targets safely to reconcile state.

GitLab
- CLI: `glab` is installed via brew. Authenticate with `glab auth login`.
- Zsh aliases (if `glab` present):
  - `gmr`: create MR from current branch (`--fill --remove-source-branch`).
  - `gml`: list MRs assigned to you.
  - `gms`: MR status.
  - `gci`: view CI pipeline.

Git Workflow Helpers
- `git diverge [remote]`: Show Ahead/Behind vs default branch of remote (default `origin`).
- `git prep-merge [remote]`: Ensure clean tree, show divergence, and open an interactive rebase onto the default branch (squash to one commit before merge).
- `git sync-default [remote]`: Fetch and rebase onto the default branch.

VS Code
- Settings are stowed to `~/Library/Application Support/Code/User/settings.json` (macOS).
- `make vscode` creates a user-writable `code` CLI symlink and installs extensions in `vscode/extensions.txt`.

Ghostty
- Config is stowed to `~/.config/ghostty/config` and uses your login shell by default.

Dock
- `make macos` pins Ghostty, VS Code, Obsidian, and draw.io to the Dock (requires `dockutil`, installed via `make brew-core`).

Applications
- `make brew-dev` also runs `scripts/ensure-cask-links.sh` to create (or refresh) symlinks in `/Applications` (or `~/Applications` if you lack write access) for Ghostty, VS Code, Obsidian, and draw.io.

Quality-of-Life Helpers
- `code-dotfiles`: Opens this repo in VS Code (auto-detects path or use `DOTFILES_REPO_DIR`).
- `sshx`: FZF SSH host picker based on `~/.ssh/config*` entries.
- `ssh-host <host> [--user u] [--port p] [--proxyjump j]`: Generates per-host key and `config.d/<host>.conf`.
- `repo`: Fuzzy browse + clone GitHub/GitLab repos into `~/repos/{work,personal}` and cd.
- `aa`: FZF alias browser, inserts the chosen alias expansion into your prompt.
- `m`: Run `make` from the nearest parent with a Makefile.
- `mt`: FZF-choose `make` target from the nearest Makefile, then run it.
- `gpm1`: Non-interactive squash of your branch to one commit onto default branch.
