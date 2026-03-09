#!/bin/bash
set -euo pipefail

osascript <<'APPLESCRIPT'
tell application "System Events"
  if not (exists process "WeChat") then error "WeChat is not running"
  tell process "WeChat"
    if (count of windows) is 0 then error "WeChat has no visible window"
    set {xPos, yPos} to position of window 1
    set {wSize, hSize} to size of window 1
    return (xPos as text) & "," & (yPos as text) & "," & (wSize as text) & "," & (hSize as text)
  end tell
end tell
APPLESCRIPT
