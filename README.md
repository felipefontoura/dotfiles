# Dotfiles

This repository contains my personal configuration files for various applications and tools, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Directory Structure

- **[alacritty](./alacritty/)**: Configuration files for the Alacritty terminal emulator.
- **[asdf](./asdf/)**: Configuration files for ASDF version manager.
- **[btop](./btop/)**: Configuration files for the Btop monitor resources.
- **[cava](./cava/)**: Configuration files for the cross-platform Audio Visualizer
- **[fastfetch](./fastfetch/)**: Configuration files for system information tool.
- **[git](./git/)**: Git configuration files.
- **[GTK](./gtk/)**: GTK theme settings files.
- **[i3](./i3/)**: Configuration files for the i3 window manager.
- **[nvim](./nvim/)**: Configuration files for Neovim.
- **[picom](./picom/)**: Configuration files for the Picom compositor.
- **[polybar](./polybar/)**: Configuration files for the Polybar status bar.
- **[powerlevel 10k](./p10k/)**: Configuration files for powerlevel 10k.
- **[rofi](./rofi/)**: Configuration files for the application launcher and dmenu replacement.
- **[ruby](./ruby/)**: Configuration files for ruby gems.
- **[superfile](./superfile/)**: Configuration files for terminal file manager.
- **[tmux](./tmux/)**: Configuration files for terminal multiplex.
- **[zsh](./zsh/)**: Configuration files for the Zsh shell.

## Prerequisites

Make sure you have GNU Stow installed. You can install it using your package manager. For example, on a Arch-based system:

```sh
sudo pacman -S stow
```

## Usage

### Option 1: Manual Installation

To use these dotfiles, clone the repository to your home directory and use Stow to create symbolic links to the appropriate locations. For example:

```sh
git clone https://github.com/felipefontoura/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Stow individual configurations
stow alacritty
stow asdf
stow btop
stow cava
stow fastfetch
stow git
stow gtk
stow i3
stow nvim
stow p10k
stow picom
stow polybar
stow rofi
stow ruby
stow superfile
stow tmux
stow zsh
```

This will create symbolic links in your home directory pointing to the files in the `.dotfiles` repository.

### Option 2: Automated Setup Script

For a complete system setup including dotfiles installation, you can use the included setup script:

```sh
git clone https://github.com/felipefontoura/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash setup.sh
```

The setup script will:

- Install YAY (AUR helper)
- Set up ZSH with plugins
- Install and configure dotfiles using Stow
- Install development tools (ASDF, Node.js, Ruby, Python)
- Install desktop applications and utilities
- Configure system services

You can review the script before running it to customize it to your needs.

## License

This repository is licensed under the [MIT License](https://mit-license.org/).
