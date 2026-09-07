#!/usr/bin/env bash
# Claude Code Notification hook: macOS notification when Claude needs you.
# Fires for permission_prompt, idle_prompt, and agent_needs_input (see
# settings.json). Skipped when the terminal is already frontmost.
set -u

input=$(cat)
j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }

front=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || true)
case "$front" in
  Ghostty|ghostty|iTerm2|Terminal|WezTerm|kitty|Alacritty) exit 0 ;;
esac

title=$(j '.title // "Claude Code"')
message=$(j '.message // "Needs your attention"')
project=$(basename "$(j '.cwd // ""')")
[[ -n $project && $project != "." ]] && title="${title} · ${project}"

# escape for AppleScript string literals
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

osascript -e "display notification \"$(esc "$message")\" with title \"$(esc "$title")\" sound name \"Glass\"" >/dev/null 2>&1 || true
exit 0
