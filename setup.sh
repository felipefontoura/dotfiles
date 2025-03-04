#!/bin/bash

##
# YAY
#

echo "Install YAY..."
sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si

##
# Shell
#

echo "Install Shell and Utils..."
yay -Sy --noconfirm zsh bat exa fd ripgrep procs grex btop dust tmux superfile-bin stow ufw curl usbutils pwgen wmctrl dosfstools exfatprogs ntfs-3g f2fs-tools p7zip rar zip unzip rsync rclone man-db man-pages fastfetch zsh-theme-powerlevel10k ttf-ibmplex-mono-nerd
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search
chsh -s /usr/bin/zsh

##
# Dotfiles
#

echo "Clonning dotfiles..."
git clone https://github.com/felipefontoura/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

stow alacritty
stow asdf
stow btop
stow cava
stow fastfetch
stow git
stow i3
stow nvim
stow p10k
stow picom
stow polybar
stow rofi
stow ruby
stow superfile
stow tmux
stow x
stow zsh

##
# Development
#

echo "Install Development and Utils..."

# ASDF
yay -Sy --noconfirm asdf-vm
mkdir -p "$HOME/.asdf/completions"
asdf completion zsh > "$HOME/.asdf/completions/_asdf"

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin add python

asdf install nodejs 22.14.0 --default
asdf install ruby 3.4.1 --default
asdf install python 3.13.2

zsh ~/.zshrc

# Ruby on Rails
yay -Sy --noconfirm libvips

# Nodejs
npm install -g yarn neovim

# Neovim
yay -Sy --noconfirm docker docker-buildx lazydocker-bin lazygit neovim neovim-notify xclip tree-sitter-cli fzf harper jdk-openjdk 

##
# Desktop
#

echo "Install Desktop Applications..."

# Browsers
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
yay -Sy --noconfirm brave-bin firefox tor-browser-bin chromium

# Communication
yay -Sy --noconfirm thunderbird thunderbird-i18n-pt-br hunspell-en_us hunspell-pt-br zoom

# Fonts
yay -Sy --noconfirm ttf-opensans ttf-ubuntu-font-family ttf-bitstream-vera ttf-liberation noto-fonts ttf-ms-fonts ttf-caladea ttf-carlito ttf-dejavu ttf-gentium-basic ttf-linux-libertine-g adobe-source-code-pro-fonts adobe-source-sans-fonts adobe-source-serif-fonts noto-fonts-emoji

# Games
yay -Sy --noconfirm minecraft-launcher

# i3
yay -Sy --noconfirm polybar picom rofi maim i3lock-color brightnessctl cava rofi-calc

# Theme and Icons
yay -Sy --noconfirm papirus-icon-theme

# Utils
yay -Sy --noconfirm logseq-desktop-bin anki-bin rnote keepassxc transmission-gtk localsend-bin

# Keyboard
yay -Sy --noconfirm kbd-br-thinkpad

# Video
yay -Sy --noconfirm inkscape gimp blender audacity obs-studio v4l2loopback-dkms obs-source-clone obs-move-transition handbrake vlc yt-dlp metadata-cleaner

##
# Commands
#

echo "System..."

# Bluetooth
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service

# CUPS
yay -Sy --noconfirm cups brother-hl1210w
sudo systemctl start cups.service
sudo systemctl enable cups.service
sudo lpadmin -p Brother-HL-1212W -E -v ipp://192.168.15.84 -m brother-HL1210W-cups-en.ppd -o media=iso_a4_210x297mm

# UFW

sudo echo "[LocalSend]
title=LocalSend
description=An open-source cross-platform alternative to AirDrop
ports=53317
" > /etc/ufw/applications.d/localsend
sudo ufw app update LocalSend
sudo ufw allow localsend

sudo ufw default deny
sudo systemctl start ufw.service
sudo systemctl enable ufw.service

##
# Cleanup
#
rm -rf ~/go
pacman -Qdtq | sudo pacman -Rns -
yay -Scc --noconfirm
