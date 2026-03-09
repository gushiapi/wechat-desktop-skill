#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: send_text.sh [--paste-only] <message>" >&2
  exit 1
}

paste_only=0
if [[ "${1:-}" == "--paste-only" ]]; then
  paste_only=1
  shift
fi

[[ $# -ge 1 ]] || usage
message="$*"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
osascript -e 'tell application "WeChat" to activate' >/dev/null
bounds="$("$SCRIPT_DIR/window_bounds.sh")"
IFS=, read -r x y width height <<<"$bounds"
swift "$SCRIPT_DIR/wechat_ui.swift" click-relative "$x" "$y" "$width" "$height" 0.76 0.92 >/dev/null

old_clipboard="$(mktemp)"
trap 'pbcopy < "$old_clipboard"; rm -f "$old_clipboard"' EXIT
pbpaste >"$old_clipboard" || true
printf '%s' "$message" | pbcopy

osascript -e 'tell application "System Events" to keystroke "v" using command down' >/dev/null
if [[ "$paste_only" -eq 0 ]]; then
  osascript -e 'tell application "System Events" to key code 36' >/dev/null
fi
