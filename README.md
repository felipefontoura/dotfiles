# Dotfiles

This repository contains my personal configuration files for various applications and tools, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Directory Structure

- **[alacritty](./alacritty/)**: Configuration files for the Alacritty terminal emulator.
- **[git](./git/)**: Git configuration files.
- **[i3](./i3/)**: Configuration files for the i3 window manager.
- **[nvim](./nvim/)**: Configuration files for Neovim.
- **[picom](./picom/)**: Configuration files for the Picom compositor.
- **[polybar](./polybar/)**: Configuration files for the Polybar status bar.
- **[rofi](./rofi/)**: Configuration files for the application launcher and dmenu replacement.
- **[zsh](./zsh/)**: Configuration files for the Zsh shell.

## Prerequisites

Make sure you have GNU Stow installed. You can install it using your package manager. For example, on a Arch-based system:

```sh
sudo pacman -S stow
```

## Usage

To use these dotfiles, clone the repository to your home directory and use Stow to create symbolic links to the appropriate locations. For example:

```sh
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Stow individual configurations
stow alacritty
stow git
stow i3
stow nvim
stow picom
stow polybar
stow rofi
stow zsh
```

This will create symbolic links in your home directory pointing to the files in the `.dotfiles` repository.

## License

This repository is licensed under the [MIT License](https://mit-license.org/).
