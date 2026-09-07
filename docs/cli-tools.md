# CLI Tools

Every tool installed via `brew/Brewfile.base` and `brew/Brewfile.apps`, plus Claude Code from its native installer.

## AI Coding Agents

| Tool | Install | Description |
|------|---------|-------------|
| [Claude Code](https://claude.com/product/claude-code) (`claude`) | `make claude-install` (native, self-updating) | The daily driver. See [shell.md](shell.md#claude-code) for `clc` and friends |
| [Entire](https://entire.io) | cask | Session checkpoints for Claude Code |
| [Codex](https://github.com/openai/codex) | cask | OpenAI coding agent |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | formula | Google coding agent |

## Core CLI (`Brewfile.base`)

### Shell & Prompt

| Tool | Description |
|------|-------------|
| [starship](https://starship.rs) | Cross-shell prompt |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like autosuggestions for zsh |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Syntax highlighting for zsh |
| [atuin](https://atuin.sh) | Shell history (Ctrl+R) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) (`z`) | Smarter cd with frecency tracking |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for files, history, branches |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info |
| [stow](https://www.gnu.org/software/stow/) | Symlink farm manager for dotfiles |

### Git & Version Control

| Tool | Description |
|------|-------------|
| [git-delta](https://github.com/dandavison/delta) | Better git diff viewer with syntax highlighting |
| [git-cliff](https://github.com/orhun/git-cliff) | Changelog generator from conventional commits |
| [gh](https://cli.github.com) | GitHub CLI (config stowed from `dotfiles/gh`) |
| [glab](https://gitlab.com/gitlab-org/cli) | GitLab CLI |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

### Search, Files & Viewing

| Tool | Description |
|------|-------------|
| [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) | Fast recursive grep replacement |
| [fd](https://github.com/sharkdp/fd) | Fast find replacement |
| [bat](https://github.com/sharkdp/bat) | cat with syntax highlighting |
| [eza](https://github.com/eza-community/eza) | Modern ls replacement with git status |
| [tree](https://mama.indstate.edu/users/ice/tree/) | Directory tree viewer |
| [yazi](https://yazi-rs.github.io) (`y`) | Terminal file manager |
| [neovim](https://neovim.io) (`nvim`) | Modern vim with LazyVim config |
| [jq](https://jqlang.github.io/jq/) | JSON processor |

### System Monitoring

| Tool | Description |
|------|-------------|
| [bottom](https://github.com/ClementTsang/bottom) (`btm`) | Better top/htop |
| [procs](https://github.com/dalance/procs) | Better ps with color and tree view |
| [dust](https://github.com/bootandy/dust) | Better du (disk usage visualization) |

### Dev Tooling

| Tool | Description |
|------|-------------|
| [mise](https://mise.jdx.dev) | Runtime version manager (Ruby, Node, Python, Go, Rust) |
| [direnv](https://direnv.net) | Per-directory environment variables |
| [watchman](https://facebook.github.io/watchman/) | File watcher |
| [tlrc](https://github.com/tldr-pages/tlrc) (`tldr`) | Command examples |
| [hyperfine](https://github.com/sharkdp/hyperfine) | CLI benchmarking |
| [tokei](https://github.com/XAMPPRocky/tokei) | Code statistics |
| [httpie](https://httpie.io) / [xh](https://github.com/ducaale/xh) | Better curl for APIs |
| [actionlint](https://github.com/rhysd/actionlint) | GitHub Actions workflow linter |
| [shellcheck](https://www.shellcheck.net) | Shell script linter |
| [exiftool](https://exiftool.org) | Image metadata |
| [cliclick](https://github.com/BlueM/cliclick) | Scriptable mouse and keyboard for macOS |
| [yarn](https://yarnpkg.com) / [nx](https://nx.dev) | JS workspace tooling (node comes from mise) |

### Mobile / App Store

| Tool | Description |
|------|-------------|
| [cocoapods](https://cocoapods.org) | iOS dependency manager |
| [asc](https://asccli.sh) | App Store Connect CLI |
| [greenlight](https://github.com/RevylAI/greenlight) | App Store / Play pre-submission compliance scanner |
| [maestro](https://maestro.mobile.dev) | Mobile E2E testing |

### Cloud & Infrastructure

| Tool | Description |
|------|-------------|
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes CLI |
| [helm](https://helm.sh) | Kubernetes package manager |
| [terraform](https://www.terraform.io) | Infrastructure as code |
| [ansible](https://www.ansible.com) | Automation/config management |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI |
| [supabase](https://supabase.com/docs/guides/cli) | Supabase CLI (local stack, migrations, functions) |
| [gcloud](https://cloud.google.com/sdk) | Google Cloud CLI (cask) |
| [dockutil](https://github.com/kcrawford/dockutil) | macOS Dock management |

## GUI Apps (`Brewfile.apps`)

| App | Description |
|-----|-------------|
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |
| [Obsidian](https://obsidian.md) | Markdown knowledge base |
| [draw.io](https://www.drawio.com) | Diagramming tool |
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Containers |

### Fonts

- JetBrains Mono
- JetBrains Mono Nerd Font
- Symbols Only Nerd Font
- Fira Code Nerd Font

## Language Runtimes (via mise)

Configured in `dotfiles/mise/.config/mise/config.toml`:

| Runtime | Version |
|---------|---------|
| Ruby | 4 |
| Node | lts |
| Python | 3.14 |
| Go | 1.25 |
| Rust | stable |
| ansible-core | 2.20.1 |
