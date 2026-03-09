---
name: "wechat-desktop"
description: "Use when Codex needs to interact with the macOS WeChat desktop app (WeChat or 微信) to detect the active window, capture visible chat context, scroll the right-side message pane without changing chats, draft replies, or send a user-approved message."
---

# WeChat Desktop

Use the bundled scripts to operate the visible macOS WeChat window with conservative UI automation. Prefer screenshot-based reading plus targeted mouse actions over keyboard navigation.

## Workflow
1. Verify that WeChat is running and that a normal app window exists.
   - Run `scripts/window_bounds.sh` to get `x,y,width,height`.
   - If this fails, stop and tell the user that WeChat is not available or macOS accessibility permissions are missing.
2. Capture before acting.
   - Run `scripts/capture_window.sh <output-path>` and inspect the image.
   - Do not assume the active chat is correct without a fresh screenshot.
3. For history review, operate only inside the right message pane.
   - Use `scripts/focus_message_pane.sh` to put focus in the message area.
   - Use `scripts/scroll_history.sh <lines>` to scroll upward through history.
   - Never use `Page Up`, `Up Arrow`, or other keyboard navigation to browse history because those can switch chats or move input focus unpredictably.
4. Draft in chat first, send second.
   - Read the visible context, then propose a reply in plain language.
   - If the user wants the message sent, use `scripts/send_text.sh --paste-only "..."` first when you need a last visual confirmation.
   - Use `scripts/send_text.sh "..."` only after the user has approved the exact text or explicitly delegated sending.
5. Re-capture after meaningful actions.
   - After switching chats, scrolling a long distance, or sending a message, take another screenshot and verify the state.

## Safety Rules
- Treat UI automation as fragile. Re-check the current window before each send.
- Keep the cursor inside the right pane for reading history. Do not click the left chat list unless intentionally changing conversations.
- Prefer short, reversible actions: click, scroll, screenshot, inspect.
- When smoke-testing paste or send behavior, prefer a user-designated sandbox chat instead of the active conversation. Use a dedicated low-risk test chat chosen by the user.
- If a script behaves unexpectedly, stop and inspect a fresh screenshot instead of trying multiple blind retries.
- Call out uncertainty. You can read only what is visible or what the client loads after scrolling.

## Coordinate Model
The scripts compute positions from the main WeChat window bounds instead of hard-coding screen coordinates.

- Message pane focus point: about `72%` from the left and `23%` from the top.
- Input box focus point: about `76%` from the left and `92%` from the top.
- These ratios matched the desktop layout used during validation and avoid the left chat list in the default window size. Chat switching uses `Cmd+F` search instead of clicking the search box directly.

## Scripts
- `scripts/window_bounds.sh`
  - Print `x,y,width,height` for the front WeChat window.
- `scripts/capture_window.sh <output-path>`
  - Capture the current WeChat window to an image file with `screencapture`.
- `scripts/open_chat.sh "chat name"`
  - Activate WeChat, open global search with `Cmd+F`, paste the chat name, and open the first match with Return.
- `scripts/focus_message_pane.sh`
  - Activate WeChat and click inside the right message pane.
- `scripts/scroll_history.sh [lines]`
  - Focus the message pane and scroll upward by the requested number of lines. Default: `18`.
- `scripts/send_text.sh [--paste-only] "message"`
  - Focus the input box, paste text through the clipboard, and optionally press Return to send.

## Permissions
The host Mac must grant this app:
- Accessibility access for mouse and keyboard automation.
- Screen Recording access for screenshots.

If permissions are missing, explain the missing capability instead of retrying.
