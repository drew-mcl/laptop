# shellcheck disable=SC1090

# --- Homebrew ----------------------------------------------------------------
if [[ -z ${HOMEBREW_PREFIX:-} ]]; then
  for brew_candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "${brew_candidate}" ]]; then
      eval "$("${brew_candidate}" shellenv)"
      break
    fi
  done
fi

typeset -gU path PATH fpath
path=("$HOME/.bundle/bin" "$HOME/.local/bin" $path)

path_prepend_if_exists() {
  local dir
  for dir in "$@"; do
    [[ -n $dir && -d $dir ]] || continue
    path=("$dir" $path)
  done
}

# --- History & editing -------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt CORRECT

bindkey -e
export ENABLE_CORRECTION="true"
export SPROMPT='zsh: correct %F{yellow}%R%f to %F{green}%r%f [nyae]? '

# --- Catppuccin Frappe palette for CLI tools ---------------------------------
# https://github.com/catppuccin/fzf (themes/catppuccin-fzf-frappe.sh)
export BAT_THEME="Catppuccin Frappe"
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
  --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
  --color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
  --color=selected-bg:#51576d,border:#737994,label:#c6d0f5 \
  --border=rounded --prompt='> ' --pointer='◆' --marker='>' \
  --separator='─' --scrollbar='│' --info=right"

# --- Completions (must precede oh-my-zsh, which runs compinit) ---------------
# Generated completions are cached here so compinit only runs once.
_zsh_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
[[ -d $_zsh_comp_cache ]] || mkdir -p "$_zsh_comp_cache"
fpath=("$_zsh_comp_cache" $fpath)

if command -v entire >/dev/null 2>&1; then
  if [[ ! -s "$_zsh_comp_cache/_entire" || "$(command -v entire)" -nt "$_zsh_comp_cache/_entire" ]]; then
    entire completion zsh >"$_zsh_comp_cache/_entire" 2>/dev/null
  fi
fi
unset _zsh_comp_cache

# --- Oh My Zsh & plugins -----------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fzf)

if [[ -d "$ZSH" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  asugg="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r $asugg ]] && source "$asugg"
  synhl="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r $synhl ]] && source "$synhl"
  fzf_dir="$HOMEBREW_PREFIX/opt/fzf"
  [[ -r "$fzf_dir/shell/key-bindings.zsh" ]] && source "$fzf_dir/shell/key-bindings.zsh"
  [[ -r "$fzf_dir/shell/completion.zsh" ]] && source "$fzf_dir/shell/completion.zsh"
  unset asugg synhl fzf_dir
fi

# --- Tooling hooks -----------------------------------------------------------
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v go >/dev/null 2>&1; then
  export GOPATH="${GOPATH:-$HOME/go}"
  export GOBIN="$GOPATH/bin"
  path_prepend_if_exists "$GOBIN"
fi

# gcloud (installed via the gcloud-cli cask)
if [[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk/bin" ]]; then
  path_prepend_if_exists "${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk/bin"
  export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-$(command -v python3)}"
fi

# --- zoxide (smarter cd) -----------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# --- atuin (shell history) ---------------------------------------------------
# Binds to Ctrl+R only, preserving up arrow for zsh-autosuggestions
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# --- yazi (file manager with cd on exit) -------------------------------------
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- Prompt ------------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PROMPT='%n@%m %1~ %# '
fi

# --- Aliases -----------------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -lah --git --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias ll='ls -lah'
fi

# Modern CLI replacements
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  alias less='bat'
fi
command -v dust >/dev/null 2>&1 && alias du='dust'
command -v procs >/dev/null 2>&1 && alias ps='procs'
if command -v btm >/dev/null 2>&1; then
  alias top='btm'
  alias htop='btm'
fi
alias vim='nvim'
alias vi='nvim'
alias be='bundle exec'

# --- Git ---------------------------------------------------------------------
# oh-my-zsh's git plugin defines these as aliases; drop them so we can define
# smarter functions with the same names.
for _a in gco gs gb gl gla gd gds gp gwt; do unalias "$_a" 2>/dev/null; done
unset _a

alias gs='git status -sb'
alias gb='git branch -vv --sort=-committerdate'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git pull --ff-only && git push'
alias gpm='git prep-merge'
alias gpm1='git prep-merge-squash'

# gco: checkout. With no args, fzf over local + remote branches by recency.
gco() {
  if (( $# )); then git checkout "$@"; return; fi
  command -v fzf >/dev/null 2>&1 || { git branch --sort=-committerdate; return; }
  local branch
  branch=$(
    git branch -a --sort=-committerdate --format='%(refname:short)' 2>/dev/null |
      sed 's#^origin/##' | grep -vx 'HEAD' | awk '!seen[$0]++' |
      fzf --prompt='branch> ' --height=50% \
          --preview 'git log --oneline --color=always --decorate -20 {}'
  ) || return 1
  [[ -n $branch ]] && git checkout "$branch"
}

# gwt: list worktrees for the current repo with age and dirty state.
gwt() {
  git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print $2}' | while read -r wt; do
    local br dirty age
    br=$(git -C "$wt" branch --show-current 2>/dev/null)
    dirty=$(git -C "$wt" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    age=$(stat -f %Sm -t %Y-%m-%d "$wt" 2>/dev/null)
    printf "  %-50s %-30s %s %s\n" "${wt/#$HOME/~}" "${br:-detached}" "$age" "$([[ $dirty != 0 ]] && echo "(${dirty} changed)")"
  done
}

# --- Claude Code -------------------------------------------------------------
# clc: the daily driver. Inside a git repo it starts Claude in a fresh worktree
# (.claude/worktrees/<name>, branch worktree-<name>) so parallel sessions never
# collide. Outside a repo, or already inside a Claude worktree, it runs in place.
#   clc            # new worktree, auto-named
#   clc auth-fix   # new (or reopened) worktree named auth-fix
#   clc "#123"     # worktree branched from PR/MR 123
clc() {
  local -a args=(--dangerously-skip-permissions)
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [[ $PWD != */.claude/worktrees/* ]]; then
    args+=(--worktree)
    if (( $# )) && [[ $1 != -* ]]; then
      args+=("$1"); shift
    fi
  fi
  claude "${args[@]}" "$@"
}

# clm: Claude in the main checkout (no worktree), for quick edits and repo-wide chores.
alias clm='claude --dangerously-skip-permissions'
# clr: resume picker (returns the session to its worktree).
alias clr='claude --dangerously-skip-permissions --resume'
# clcc: continue the most recent session in this directory.
alias clcc='claude --dangerously-skip-permissions --continue'

# zc <repo>: jump to a repo with zoxide and start clc there.
zc() {
  (( $# )) || { echo "usage: zc <repo>" >&2; return 1; }
  z "$1" && clc
}

# --- GitLab ------------------------------------------------------------------
if command -v glab >/dev/null 2>&1; then
  alias gmr='glab mr create --fill --remove-source-branch'
  alias gml='glab mr list --mine'
  alias gms='glab mr status'
  alias gci='glab ci view'

  gmco() {
    command -v fzf >/dev/null 2>&1 || { echo "fzf not installed" >&2; return 1; }
    local line id
    line=$(glab mr list --state opened --no-headers -n 100 2>/dev/null | fzf --ansi --prompt='MR> ' --height=60%) || return 1
    id=$(echo "$line" | awk '{print $1}')
    [[ -n $id ]] || return 1
    glab mr checkout "$id"
  }
fi

# --- Helpers -----------------------------------------------------------------
_find_makefile_dir() {
  local dir="$PWD"
  while [[ "$dir" != "/" && ! -f "$dir/Makefile" ]]; do
    dir="${dir:h}"
  done
  [[ -f "$dir/Makefile" ]] || { echo "No Makefile found" >&2; return 1; }
  echo "$dir"
}

m() {
  local dir
  dir=$(_find_makefile_dir) || return 1
  (cd "$dir" && make "$@")
}

mt() {
  command -v fzf >/dev/null 2>&1 || { echo "fzf not installed" >&2; return 1; }
  local dir target
  dir=$(_find_makefile_dir) || return 1
  target=$(
    make -qp -C "$dir" 2>/dev/null |
      awk -F':' '/^[[:alnum:]][^$#\/\t=]*:([^=]|$)/ {print $1}' |
      sort -u |
      fzf --prompt='make> ' --height=60%
  ) || return 1
  (cd "$dir" && make "$target")
}

aa() {
  command -v fzf >/dev/null 2>&1 || { echo "fzf not installed" >&2; return 1; }
  local selection name body
  selection=$(alias | fzf --prompt='alias> ' --preview 'echo {}' --height=60%) || return 1
  name=${selection#alias }
  name=${name%%=*}
  body=${selection#*=}
  body=${body#\'}
  body=${body%\'}
  body=${body#\"}
  body=${body%\"}
  print -z -- "$body"
}

sshx() {
  command -v fzf >/dev/null 2>&1 || { echo "fzf not installed" >&2; return 1; }
  local -a config_files=()
  [[ -f "$HOME/.ssh/config" ]] && config_files+=("$HOME/.ssh/config")
  if [[ -d "$HOME/.ssh/config.d" ]]; then
    config_files+=("$HOME/.ssh/config.d"/*(.N))
  fi
  (( ${#config_files[@]} )) || { echo "No SSH config files found" >&2; return 1; }
  local hosts host
  hosts=$(awk '/^Host /{for(i=2;i<=NF;i++) if ($i !~ /[\*\?]/) print $i}' "${config_files[@]}" 2>/dev/null | sort -u)
  [[ -n $hosts ]] || { echo "No SSH hosts found" >&2; return 1; }
  host=$(printf '%s\n' "$hosts" | fzf --prompt='ssh> ' --height=60%) || return 1
  [[ -n $host ]] && ssh "$host"
}

ssh-host() {
  local script="${MACOS_SETUP:-$HOME/repos/macos}/scripts/ssh-host.sh"
  [[ -x $script ]] || { echo "ssh-host.sh script not found" >&2; return 1; }
  bash "$script" "$@"
}

envim() {
  local dir="$PWD" envfile
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.env" ]]; then
      envfile="$dir/.env"
      break
    fi
    dir="${dir:h}"
  done
  if [[ -z $envfile ]]; then
    echo "No .env file found" >&2
    return 1
  fi
  nvim "$envfile"
}

# repo: fzf over local ~/repos plus GitHub/GitLab remotes; cd or clone.
repo() {
  command -v fzf >/dev/null 2>&1 || { echo "fzf not installed" >&2; return 1; }
  local -a rows=()
  local d
  for d in "$HOME/repos"/*(/N); do
    [[ -d "$d/.git" ]] && rows+=("local\t${d:t}\t${d}")
  done
  if command -v gh >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    while IFS=$'\t' read -r name url; do
      rows+=("github\t${name}\t${url}")
    done < <(gh repo list --limit 500 --json nameWithOwner,sshUrl 2>/dev/null | jq -r '.[] | [.nameWithOwner, .sshUrl] | @tsv')
  fi
  if command -v glab >/dev/null 2>&1; then
    while read -r line; do
      local path
      path=$(echo "$line" | awk '{print $1}')
      [[ -z $path ]] && continue
      rows+=("gitlab\t${path}\tgit@gitlab.com:${path}.git")
    done < <(glab repo list --no-headers -n 200 2>/dev/null || true)
  fi
  (( ${#rows[@]} )) || { echo "No repos found" >&2; return 1; }
  local selection source name url destination_dir
  selection=$(printf '%s\n' "${rows[@]}" | column -t -s $'\t' | fzf --ansi --prompt='repo> ' --height=80% --preview 'echo {1} {2}\n{3}') || return 1
  source=$(echo "$selection" | awk '{print $1}')
  name=$(echo "$selection" | awk '{print $2}')
  url=$(echo "$selection" | awk '{print $3}')
  if [[ $source == local ]]; then
    cd "$url"
    return 0
  fi
  destination_dir="$HOME/repos/${name##*/}"
  if [[ -d "$destination_dir/.git" ]]; then
    echo "Exists: $destination_dir"
    cd "$destination_dir"
    return 0
  fi
  git clone "$url" "$destination_dir" && cd "$destination_dir"
}

# --- ws: workstation config manager ------------------------------------------
ws() {
  local WS="${MACOS_SETUP:-$HOME/repos/macos}"
  case "${1:-help}" in
    brew)     $EDITOR "$WS/brew/Brewfile.base" ;;
    zsh)      $EDITOR "$WS/dotfiles/zsh/.zshrc" ;;
    env)      $EDITOR "$WS/dotfiles/zsh/.zshenv" ;;
    git)      $EDITOR "$WS/dotfiles/git/.gitconfig" ;;
    ghostty)  $EDITOR "$WS/dotfiles/ghostty/.config/ghostty/config" ;;
    nvim)     $EDITOR "$WS/dotfiles/nvim/.config/nvim/" ;;
    mise)     $EDITOR "$WS/dotfiles/mise/.config/mise/config.toml" ;;
    star)     $EDITOR "$WS/dotfiles/starship/.config/starship.toml" ;;
    ssh)      $EDITOR "$WS/dotfiles/ssh/.ssh/config" ;;
    tips)     $EDITOR "$WS/dotfiles/zsh/.config/zsh/tips.txt" ;;
    claude)
      case "${2:-md}" in
        md)       $EDITOR "$WS/dotfiles/claude/.claude/CLAUDE.md" ;;
        settings) $EDITOR "$WS/dotfiles/claude/.claude/settings.json" ;;
        status)   $EDITOR "$WS/dotfiles/claude/.claude/statusline.sh" ;;
        hooks)    $EDITOR "$WS/dotfiles/claude/.claude/hooks/" ;;
        *)        echo "usage: ws claude [md|settings|status|hooks]" >&2; return 1 ;;
      esac
      ;;
    edit)     fd . "$WS" -H --type f -E .git | fzf --preview 'bat --color=always {}' | xargs -r $EDITOR ;;
    sync)     git -C "$WS" add -A && git -C "$WS" commit -m "sync: $(date +%Y-%m-%d-%H%M)" && git -C "$WS" push ;;
    stow)     make -C "$WS" stow ;;
    update)   make -C "$WS" refresh ;;
    doctor)
      local brewfiles=("$WS/brew/Brewfile.base" "$WS/brew/Brewfile.apps")
      echo "=== Brew: in Brewfile, not installed ==="
      local f
      for f in "${brewfiles[@]}"; do
        brew bundle check --file="$f" 2>&1 | grep -v 'are satisfied' || true
      done
      echo ""
      echo "=== Brew: installed, not in Brewfile ==="
      comm -23 <(brew leaves | sort) <(cat "${brewfiles[@]}" | grep -oE '^brew "[^"]+"' | sed 's/brew "//;s/"//' | sort) | sed 's/^/  formula  /'
      comm -23 <(brew list --cask | sort) <(cat "${brewfiles[@]}" | grep -oE '^cask "[^"]+"' | sed 's/cask "//;s/"//' | sort) | sed 's/^/  cask     /'
      echo ""
      echo "=== Mise ==="
      mise ls --missing 2>/dev/null | sed 's/^/  missing  /'
      echo ""
      echo "=== Stow ==="
      local pkg pkg_name
      for pkg in "$WS"/dotfiles/*/; do
        pkg_name=$(basename "$pkg")
        if stow --no-folding --simulate -d "$WS/dotfiles" -t "$HOME" "$pkg_name" 2>&1 | grep -q .; then
          echo "  $pkg_name: needs restow (or has conflicts)"
        fi
      done
      echo ""
      echo "=== Claude Code ==="
      if [[ -L "$HOME/.claude/settings.json" ]]; then
        echo "  settings.json  stowed"
      else
        echo "  settings.json  NOT stowed (run: make stow-clean)"
      fi
      local -a claudes=("${(@f)$(whence -pa claude 2>/dev/null)}")
      if (( ${#claudes[@]} > 1 )); then
        echo "  duplicate claude binaries on PATH:"
        printf "    %s\n" "${claudes[@]}"
      else
        echo "  claude         ${claudes[1]:-missing} ($(claude --version 2>/dev/null | head -1))"
      fi
      echo ""
      echo "=== Tool Versions ==="
      make -C "$WS" doctor
      ;;
    profile)
      echo "=== Shell startup time ==="
      for i in 1 2 3; do
        /usr/bin/time zsh -i -c exit 2>&1
      done
      echo ""
      echo "=== Top functions by time ==="
      zsh -ic 'zmodload zsh/zprof; source ~/.zshrc; zprof | head -20' 2>/dev/null
      ;;
    help|*)
      printf "\n  \033[38;5;141m\033[1mws\033[0m \033[2mworkstation config manager\033[0m\n\n"
      printf "  \033[36m%-14s\033[0m %s\n" "brew"    "Edit Brewfile"
      printf "  \033[36m%-14s\033[0m %s\n" "zsh"     "Edit .zshrc"
      printf "  \033[36m%-14s\033[0m %s\n" "env"     "Edit .zshenv"
      printf "  \033[36m%-14s\033[0m %s\n" "git"     "Edit .gitconfig"
      printf "  \033[36m%-14s\033[0m %s\n" "ghostty" "Edit Ghostty config"
      printf "  \033[36m%-14s\033[0m %s\n" "nvim"    "Edit Neovim config"
      printf "  \033[36m%-14s\033[0m %s\n" "mise"    "Edit mise runtime versions"
      printf "  \033[36m%-14s\033[0m %s\n" "star"    "Edit Starship prompt"
      printf "  \033[36m%-14s\033[0m %s\n" "ssh"     "Edit SSH config"
      printf "  \033[36m%-14s\033[0m %s\n" "tips"    "Edit terminal tips"
      printf "  \033[36m%-14s\033[0m %s\n" "claude"  "Edit CLAUDE.md [md|settings|status|hooks]"
      printf "  \033[36m%-14s\033[0m %s\n" "edit"    "FZF picker for any config"
      printf "  \033[36m%-14s\033[0m %s\n" "sync"    "Commit + push changes"
      printf "  \033[36m%-14s\033[0m %s\n" "stow"    "Re-stow all packages"
      printf "  \033[36m%-14s\033[0m %s\n" "doctor"  "Drift check: brew, mise, stow, claude"
      printf "  \033[36m%-14s\033[0m %s\n" "update"  "Brew update + restow"
      printf "  \033[36m%-14s\033[0m %s\n" "profile" "Shell startup profiling"
      printf "\n"
      ;;
  esac
}

_ws() {
  local -a commands=(brew zsh env git ghostty nvim mise star ssh tips claude edit sync stow doctor update profile help)
  if (( CURRENT == 3 )) && [[ ${words[2]} == claude ]]; then
    _values 'claude config' md settings status hooks
    return
  fi
  _describe 'ws commands' commands
}
compdef _ws ws

# --- obsidian-sync -----------------------------------------------------------
obsidian-sync() {
  local vault="${OBSIDIAN_VAULT:-$HOME/Documents/Obsidian}"
  if [[ ! -d "$vault/.git" ]]; then
    echo "Initializing git repo in $vault..."
    git -C "$vault" init
    git -C "$vault" remote add origin git@github.com:drew-mcl/obsidian.git
    git -C "$vault" branch -M main
  fi
  git -C "$vault" add -A
  git -C "$vault" commit -m "vault sync: $(date +%Y-%m-%d-%H%M)" || echo "Nothing to sync"
  git -C "$vault" push -u origin main
}

# --- Tip of the shell --------------------------------------------------------
# One random line from ~/.config/zsh/tips.txt per new terminal. Silent inside
# Claude Code shells and non-interactive sessions.
_tip() {
  local file="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/tips.txt"
  [[ -o interactive && -z ${CLAUDECODE:-} && -r $file ]] || return 0
  local -a tips
  tips=("${(@f)$(grep -Ev '^\s*(#|$)' "$file")}")
  (( ${#tips[@]} )) || return 0
  print -P "%F{#737994}tip:%f %F{#a5adce}${tips[RANDOM % ${#tips[@]} + 1]}%f"
}
_tip

# --- Start in repos ----------------------------------------------------------
# Only when the shell opens in $HOME, so new tabs opened from a repo stay there.
if [[ $PWD == "$HOME" && -z ${CLAUDECODE:-} ]]; then
  cd ~/repos 2>/dev/null || true
fi
