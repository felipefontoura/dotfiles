# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```sh
curl -sSL https://raw.githubusercontent.com/felipefontoura/dotfiles/main/setup-omarchy.sh | bash
```

## Packages

| Package | What it configures |
|---------|-------------------|
| `ai` | Claude Code, OpenCode — shared commands, skills, permissions |
| `bash` | Bash, aliases, env, functions |
| `cava` | Audio visualizer |
| `git` | Git config |
| `hyprland` | Hyprland window manager |
| `local` | Local bin scripts |
| `mpd` | Music player daemon |
| `nvim` | Neovim |
| `ruby` | Ruby/Gems config |
| `tmux` | Terminal multiplexer |
| `typora` | Markdown editor themes |

## Usage

```sh
cd ~/.dotfiles
stow <package>      # link a package
stow -R <package>   # re-link (after changes)
stow -D <package>   # unlink
```

## License

[MIT](https://mit-license.org/)
