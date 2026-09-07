#!/usr/bin/env bash
# Claude Code status line - Catppuccin Frappe.
# Receives session JSON on stdin; prints one line:
#   Fable  bardog  main*  ▓▓▓░░░░░░░ 32%  $1.23  +156/-42  5h 23%
set -u

input=$(cat)
j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }

# Frappe palette as truecolor escapes
c() { printf '\033[38;2;%sm' "$1"; }
PINK=$(c '244;184;228')
MAUVE=$(c '202;158;230')
BLUE=$(c '140;170;238')
GREEN=$(c '166;209;137')
YELLOW=$(c '229;200;144')
RED=$(c '231;130;132')
PEACH=$(c '239;159;118')
TEAL=$(c '129;200;190')
SUBTEXT=$(c '165;173;206')
OVERLAY=$(c '115;121;148')
RESET=$'\033[0m'
SEP="${OVERLAY}  ${RESET}"

model=$(j '.model.display_name // "Claude"')
dir=$(j '.workspace.current_dir // .cwd // ""')
project_dir=$(j '.workspace.project_dir // .workspace.current_dir // .cwd // ""')
wt=$(j '.worktree.name // .workspace.git_worktree // empty')
pct=$(j '.context_window.used_percentage // empty' | cut -d. -f1)
cost=$(j '.cost.total_cost_usd // empty')
added=$(j '.cost.total_lines_added // 0')
removed=$(j '.cost.total_lines_removed // 0')
five=$(j '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
week=$(j '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)

out="${MAUVE}${model}${RESET}"

# project: where Claude was launched, plus the worktree name when in one
project=$(basename "${project_dir:-$PWD}")
if [[ -n $wt && $wt != "$project" ]]; then
  project="${project} ${OVERLAY}wt:${RESET}${PINK}${wt}"
fi
out+="${SEP}${BLUE}${project}${RESET}"

# git branch + dirty marker
if [[ -n $dir ]] && git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  dirty=""
  git -C "$dir" diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty="*"
  out+="${SEP}${TEAL}${branch}${RED}${dirty}${RESET}"
fi

# context bar
if [[ -n $pct ]]; then
  filled=$(( pct / 10 ))
  (( filled > 10 )) && filled=10
  bar=""
  for (( i = 0; i < 10; i++ )); do
    if (( i < filled )); then bar+="▓"; else bar+="░"; fi
  done
  if (( pct >= 80 )); then col=$RED; elif (( pct >= 50 )); then col=$YELLOW; else col=$GREEN; fi
  out+="${SEP}${col}${bar} ${pct}%${RESET}"
fi

# cost + churn
if [[ -n $cost ]]; then
  out+="${SEP}${PEACH}$(printf '$%.2f' "$cost")${RESET}"
fi
if (( added > 0 || removed > 0 )); then
  out+="${SEP}${GREEN}+${added}${RESET}${OVERLAY}/${RED}-${removed}${RESET}"
fi

# rate limits (Pro/Max only)
limits=""
[[ -n $five ]] && limits+="5h ${five}%"
[[ -n $week ]] && limits+="${limits:+ }7d ${week}%"
[[ -n $limits ]] && out+="${SEP}${SUBTEXT}${limits}${RESET}"

printf '%s\n' "$out"
