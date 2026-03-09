# WeChat Desktop Skill

Shareable Codex skill for interacting with the macOS WeChat desktop app.

## Repo layout

```text
wechat-desktop-skill/
├── README.md
└── skills/
    └── wechat-desktop/
```

The installable skill lives at:

- [`skills/wechat-desktop`](./skills/wechat-desktop)

## What it does

This skill helps Codex:

- detect the active WeChat window
- capture the visible chat area
- switch to a chat by name
- scroll the right-side message pane without switching chats
- paste or send a user-approved message

## Requirements

- macOS
- desktop WeChat installed and logged in
- Codex running on the same machine
- Accessibility permission enabled for Codex or the host app
- Screen Recording permission enabled for Codex or the host app

This skill depends on built-in macOS tools such as `osascript`, `screencapture`, and `swift`.

## Install

### Option 1: Manual install

Copy the skill directory into `~/.codex/skills/`:

```bash
mkdir -p ~/.codex/skills
cp -R skills/wechat-desktop ~/.codex/skills/
```

Then restart Codex.

### Option 2: Install from GitHub

If you publish this folder to GitHub and keep the same structure, install it from the repo path:

```bash
python ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo <owner>/<repo> \
  --path skills/wechat-desktop
```

Then restart Codex.

## Use

In a new Codex chat, mention the skill explicitly:

- `$wechat-desktop`
- `Use $wechat-desktop to switch to a WeChat chat named "test chat".`
- `Use $wechat-desktop to read the current WeChat window and draft a reply.`

## GitHub Pages

This repo also includes a simple landing page at:

- `docs/index.html`

If you push this folder as a GitHub repo, you can enable GitHub Pages with:

- Settings
- Pages
- Build and deployment
- Source: `Deploy from a branch`
- Branch: `main`
- Folder: `/docs`

## Notes

- The skill is tuned for the standard desktop WeChat layout on macOS.
- Sending behavior is intentionally conservative; screenshot-check before risky actions.
- Chat switching is implemented through WeChat search (`Cmd+F`) rather than clicking the search box directly.
