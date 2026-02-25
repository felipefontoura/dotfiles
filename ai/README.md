# AI Tools Config

Shared configuration for [Claude Code](https://claude.ai/claude-code) and [OpenCode](https://opencode.ai/).

## Architecture

```
ai/
├── prompts/                          # Single source of truth
│   ├── commands/*.md                 # Slash commands (both tools)
│   └── skills/*/SKILL.md            # Passive skills (auto-applied)
├── .claude/
│   ├── commands → ../prompts/commands
│   ├── skills → ../prompts/skills
│   ├── settings.json                 # Model, statusline
│   ├── settings.local.json           # Permissions (gitignored)
│   └── statusline-command.sh
├── .config/opencode/
│   ├── commands → ../../prompts/commands
│   └── opencode.json                 # Model, permissions
└── .stow-local-ignore                # Prevents ~/prompts/ from deploying
```

Both tools read from the same `.md` files via symlinks. Edit once, works everywhere.

## Commands

| Command | Description |
|---------|-------------|
| `/review` | Code review with 0-10 scoring |
| `/security` | OWASP Top 10 security audit |
| `/explain` | Code explanation |
| `/test-plan` | Test plan generation |
| `/refactor` | Refactoring suggestions |
| `/analyze` | Quality analysis |
| `/commit` | Atomic commits in logical order |
| `/pr` | Create GitHub PR |
| `/pr-summary` | PR description from diff |
| `/branch` | Branch with naming convention |
| `/changelog` | Changelog from commits |
| `/merge` | Merge PR and clean up branch |
| `/design-system` | Extract design system from screenshot, URL, Figma, or codebase |

## Skills

| Skill | Trigger |
|-------|---------|
| `coding-standards` | Writing/modifying code |
| `git-workflow` | Git operations |

## Setup

```sh
cd ~/.dotfiles && stow ai
```
