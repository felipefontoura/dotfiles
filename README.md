# Dotfiles

This repository contains my personal configuration files for various applications and tools.

## Shortcuts

| Shortcut          | Action                          |
|-------------------|---------------------------------|
| `Super + 1-6`     | Switch to workspace 1-6         |
| `Super + w`       | Close window                    |
| `Super + Up`      | Maximize window                 |
| `Super + BackSpace` | Begin resize window            |
| `Shift + F11`     | Toggle fullscreen               |
| `Shift + AudioPlay` | Next media track               |
| `Alt + 1-9`       | Switch to application 1-9       |
| `Super + space`   | Toggle Ulauncher                |
| `Shift + Alt + 2` | Open new console window         |
| `Shift + Alt + 1` | Open new Brave window           |

### Extension Shortcuts

#### Space Bar (Workspace Manager)

| Shortcut          | Action                          |
|-------------------|---------------------------------|
| `Super + 1-6`     | Switch to workspace 1-6         |
| `Shift + Super + 1-6` | Move window to workspace 1-6   |

#### Tactile (Window Tiling)

| Shortcut          | Action                          |
|-------------------|---------------------------------|
| `Super + Left/Right/Up/Down` | Tile window to screen edge |
| `Super + Shift + Left/Right` | Move window between monitors |
| `Super + Ctrl + Left/Right/Up/Down` | Resize window |

## Usage

```sh
curl -sSL https://raw.githubusercontent.com/felipefontoura/dotfiles/main/setup.sh | bash
```

The setup script will:

- Install YAY (AUR helper)
- Set up ZSH with plugins
- Install and configure dotfiles using Stow
- Install development tools (ASDF, Node.js, Ruby, Python)
- Install desktop applications and utilities for GNOME
- Configure system services

## License

This repository is licensed under the [MIT License](https://mit-license.org/).
