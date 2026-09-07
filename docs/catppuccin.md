# Catppuccin Frappe Theme

Every terminal tool uses the [Catppuccin Frappe](https://github.com/catppuccin/catppuccin) flavor so the terminal, editor, pickers, and pagers share one background and one accent set (pink primary).

## Configured Tools

| Tool | Config Location | Method |
|------|----------------|--------|
| Ghostty | `dotfiles/ghostty/.config/ghostty/config` | `theme = Catppuccin Frappe` (bundled) |
| Neovim | `dotfiles/nvim/.config/nvim/lua/plugins/catppuccin.lua` | catppuccin/nvim, `flavour = "frappe"` |
| bat / `cat` | `dotfiles/zsh/.zshrc` | `BAT_THEME="Catppuccin Frappe"` (bundled with bat) |
| fzf | `dotfiles/zsh/.zshrc` | `FZF_DEFAULT_OPTS` from catppuccin/fzf |
| git-delta | `dotfiles/git/.gitconfig` | `syntax-theme = Catppuccin Frappe` |
| lazygit | `dotfiles/lazygit/.config/lazygit/config.yml` | catppuccin/lazygit pink theme |
| bottom (`btm`) | `dotfiles/bottom/.config/bottom/bottom.toml` | catppuccin/bottom frappe theme |
| Yazi | `dotfiles/yazi/.config/yazi/yazi.toml` + `package.toml` | `[flavor] dark = "catppuccin-frappe"`, installed by `ya pkg install` |
| Claude Code status line | `dotfiles/claude/.claude/statusline.sh` | Truecolor escapes from the palette below |
| Starship | `dotfiles/starship/.config/starship.toml` | Default module colors (they map onto the Ghostty palette) |
| Makefile output | `Makefile` | 256-color approximations |

## Changing the Flavor

To move to Latte, Macchiato, or Mocha:

1. **Ghostty**: `theme = Catppuccin <Flavor>`
2. **Neovim**: `flavour` and `colorscheme` in `catppuccin.lua`
3. **bat**: `BAT_THEME` in `.zshrc`
4. **fzf**: paste the flavor's `FZF_DEFAULT_OPTS` from [catppuccin/fzf](https://github.com/catppuccin/fzf) into `.zshrc`
5. **git-delta**: `syntax-theme` in `.gitconfig`
6. **lazygit**: copy the flavor file from [catppuccin/lazygit](https://github.com/catppuccin/lazygit)
7. **bottom**: copy the flavor file from [catppuccin/bottom](https://github.com/catppuccin/bottom)
8. **Yazi**: `ya pkg add yazi-rs/flavors:catppuccin-<flavor>` from the repo's yazi config dir, then update `yazi.toml`
9. **Status line**: update the RGB triples at the top of `statusline.sh`

Then `ws stow` and open a new terminal.

## Catppuccin Frappe Palette

| Name | Hex | Used for |
|------|-----|----------|
| Rosewater | `#f2d5cf` | Cursor, fzf pointer |
| Pink | `#f4b8e4` | Primary accent: active borders, worktree names |
| Mauve | `#ca9ee6` | Prompts, model name |
| Red | `#e78284` | Errors, dirty markers, hot context |
| Peach | `#ef9f76` | Cost, durations |
| Yellow | `#e5c890` | Warnings, mid context |
| Green | `#a6d189` | Success, low context, lines added |
| Teal | `#81c8be` | Git branch |
| Blue | `#8caaee` | Project name, options |
| Lavender | `#babbf1` | Markers, authors |
| Text | `#c6d0f5` | Foreground |
| Subtext0 | `#a5adce` | Secondary text, tips |
| Overlay0 | `#737994` | Separators, labels |
| Surface1 | `#51576d` | Selected background |
| Surface0 | `#414559` | Selection background |
| Base | `#303446` | Background |
| Crust | `#232634` | Selected text on accent |

## Yazi Flavor Installation

`make stow` runs `ya pkg install`, which reads `dotfiles/yazi/.config/yazi/package.toml` and installs the pinned flavor. To add or upgrade flavors:

```bash
cd ~/repos/macos/dotfiles/yazi/.config/yazi
YAZI_CONFIG_HOME=$PWD ya pkg add yazi-rs/flavors:catppuccin-frappe
YAZI_CONFIG_HOME=$PWD ya pkg upgrade
```

The `flavors/` directory is gitignored; only `package.toml` is committed.
