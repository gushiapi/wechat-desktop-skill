#!/bin/bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: open_chat.sh <chat-name>" >&2
  exit 1
fi

chat_name="$*"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

osascript -e 'tell application "WeChat" to activate' >/dev/null
sleep 0.2

old_clipboard="$(mktemp)"
trap 'pbcopy < "$old_clipboard"; rm -f "$old_clipboard"' EXIT
pbpaste >"$old_clipboard" || true
printf '%s' "$chat_name" | pbcopy

osascript <<'APPLESCRIPT' >/dev/null
tell application "System Events"
  keystroke "f" using command down
  delay 0.2
  keystroke "a" using command down
  key code 51
  keystroke "v" using command down
  delay 0.35
  key code 36
end tell
APPLESCRIPT

sleep 0.35
