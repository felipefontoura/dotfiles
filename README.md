# Dotfiles

This repository contains my personal configuration files for various applications and tools, managed using GNU Stow.

## Directory Structure

- **alacritty**: Configuration files for the Alacritty terminal emulator.
- **git**: Git configuration files.
- **i3**: Configuration files for the i3 window manager.
- **nvim**: Configuration files for Neovim.
- **picom**: Configuration files for the Picom compositor.
- **polybar**: Configuration files for the Polybar status bar.
- **zsh**: Configuration files for the Zsh shell.

## Prerequisites

Make sure you have GNU Stow installed. You can install it using your package manager. For example, on a Debian-based system:

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
stow zsh
```

This will create symbolic links in your home directory pointing to the files in the `.dotfiles` repository.

## License

This repository is licensed under the MIT License.
