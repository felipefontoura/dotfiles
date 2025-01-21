# Dotfiles

This repository contains my personal configuration files for various applications and tools, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Directory Structure

- **[alacritty](./alacritty/)**: Configuration files for the Alacritty terminal emulator.
- **[btop](./btop/)**: Configuration files for the Btop monitor resources.
- **[cava](./cava/)**: Configuration files for the cross-platform Audio Visualizer
- **[fastfetch](./fastfetch/)**: Configuration files for system information tool.
- **[git](./git/)**: Git configuration files.
- **[i3](./i3/)**: Configuration files for the i3 window manager.
- **[nvim](./nvim/)**: Configuration files for Neovim.
- **[picom](./picom/)**: Configuration files for the Picom compositor.
- **[polybar](./polybar/)**: Configuration files for the Polybar status bar.
- **[ranger](./ranger/)**: Configuration files for the Ranger file manager.
- **[rofi](./rofi/)**: Configuration files for the application launcher and dmenu replacement.
- **[superfile](./superfile/)**: Configuration files for terminal file manager.
- **[X](./x/)**: Configuration files for X.
- **[zsh](./zsh/)**: Configuration files for the Zsh shell.

## Prerequisites

Make sure you have GNU Stow installed. You can install it using your package manager. For example, on a Arch-based system:

```sh
sudo pacman -S stow
```

## Usage

To use these dotfiles, clone the repository to your home directory and use Stow to create symbolic links to the appropriate locations. For example:

```sh
git clone https://github.com/felipefontoura/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Stow individual configurations
stow alacritty
stow btop
stow cava
stow fastfetch
stow git
stow i3
stow nvim
stow picom
stow polybar
stow ranger
stow rofi
stow superfile
stow x
stow zsh
```

This will create symbolic links in your home directory pointing to the files in the `.dotfiles` repository.

## License

This repository is licensed under the [MIT License](https://mit-license.org/).
