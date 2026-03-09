#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

osascript -e 'tell application "WeChat" to activate' >/dev/null
bounds="$("$SCRIPT_DIR/window_bounds.sh")"
IFS=, read -r x y width height <<<"$bounds"
swift "$SCRIPT_DIR/wechat_ui.swift" click-relative "$x" "$y" "$width" "$height" 0.72 0.23 >/dev/null
