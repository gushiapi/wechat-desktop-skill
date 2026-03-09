#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: capture_window.sh <output-path>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_PATH="$1"
mkdir -p "$(dirname "$OUTPUT_PATH")"

bounds="$("$SCRIPT_DIR/window_bounds.sh")"
IFS=, read -r x y width height <<<"$bounds"
screencapture -R"${x},${y},${width},${height}" "$OUTPUT_PATH"
printf '%s\n' "$OUTPUT_PATH"
