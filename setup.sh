!/bin/bash

# Exit on error
set -e

# Language versions
NODEJS_VERSION="22.13.1"
RUBY_VERSION="3.4.1"
PYTHON_VERSION="3.13.2"

# Function to print section headers
print_header() {
  echo -e "\n\033[1;34m## $1\033[0m"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed (pacman)
package_installed() {
  pacman -Q "$1" >/dev/null 2>&1
}

##
# YAY
#

print_header "YAY"

if command_exists yay; then
  echo "YAY is already installed, skipping..."
else
  echo "Installing YAY..."
  sudo pacman -S --needed --noconfirm git base-devel
  
  # Clean up any previous failed attempts
  rm -rf ~/yay-bin
  
  git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
  cd ~/yay-bin
  makepkg -si --noconfirm
  cd -
  rm -rf ~/yay-bin
fi

##
# Shell
#

print_header "Shell and Utils"

echo "Installing Shell and Utils..."
yay -Sy --needed --noconfirm zsh bat exa fd ripgrep procs grex btop dust tmux superfile-bin stow ufw curl usbutils pwgen wmctrl dosfstools exfatprogs ntfs-3g f2fs-tools p7zip rar zip unzip rsync rclone man-db man-pages fastfetch zsh-theme-powerlevel10k ttf-ibmplex-mono-nerd

# ZSH plugins
ZSH_PLUGINS_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGINS_DIR"

# Install ZSH plugins if not already installed
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "Installing ZSH autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "Installing ZSH syntax highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-history-substring-search" ]; then
  echo "Installing ZSH history substring search..."
  git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_PLUGINS_DIR/zsh-history-substring-search"
fi

# Change shell to ZSH if not already
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "Changing default shell to ZSH..."
  chsh -s /usr/bin/zsh
fi

# TMUX plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TMUX plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

##
# Dotfiles
#

print_header "Dotfiles"

DOTFILES_DIR="$HOME/.dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles directory already exists, updating..."
  cd "$DOTFILES_DIR"
  git pull
else
  echo "Cloning dotfiles..."
  git clone https://github.com/felipefontoura/dotfiles.git "$DOTFILES_DIR"
  cd "$DOTFILES_DIR"
fi

# Array of configs to stow
configs=(
  "alacritty"
  "asdf"
  "btop"
  "cava"
  "fastfetch"
  "git"
  "gtk"
  "i3"
  "nvim"
  "p10k"
  "picom"
  "polybar"
  "rofi"
  "ruby"
  "superfile"
  "tmux"
  "zsh"
)

echo "Stowing configuration files..."
for config in "${configs[@]}"; do
  echo "Stowing $config..."
  stow -R "$config"
done

##
# Development
#

print_header "Development Tools"

echo "Installing Development and Utils..."

# ASDF
if ! command_exists asdf; then
  echo "Installing ASDF version manager..."
  yay -Sy --needed --noconfirm asdf-vm
  
  # Source ASDF to make it available in this script
  source /opt/asdf-vm/asdf.sh
else
  echo "ASDF already installed, skipping..."
fi

# Setup ASDF completions
mkdir -p "$HOME/.asdf/completions"
asdf completion zsh > "$HOME/.asdf/completions/_asdf"

# Install ASDF plugins
echo "Setting up ASDF plugins..."
asdf_plugins=(
  "nodejs:https://github.com/asdf-vm/asdf-nodejs.git"
  "ruby:https://github.com/asdf-vm/asdf-ruby.git"
  "python:https://github.com/asdf-vm/asdf-python.git"
)

for plugin_entry in "${asdf_plugins[@]}"; do
  plugin_name="${plugin_entry%%:*}"
  plugin_url="${plugin_entry#*:}"
  
  if ! asdf plugin list | grep -q "$plugin_name"; then
    echo "Adding ASDF plugin: $plugin_name"
    asdf plugin add "$plugin_name" "$plugin_url"
  else
    echo "ASDF plugin $plugin_name already installed, updating..."
    asdf plugin update "$plugin_name"
  fi
done

# Install language versions
echo "Installing language versions with ASDF..."
asdf install nodejs $NODEJS_VERSION
asdf install ruby $RUBY_VERSION
asdf install python $PYTHON_VERSION

# Ruby on Rails dependencies
echo "Installing Ruby on Rails dependencies..."
yay -Sy --needed --noconfirm libvips postgresql-libs

# Nodejs global packages
echo "Installing global NPM packages..."
npm install -g yarn neovim

# Neovim and development tools
echo "Installing Neovim and development tools..."
yay -Sy --needed --noconfirm docker docker-buildx lazydocker-bin lazygit neovim neovim-notify xclip tree-sitter-cli fzf harper jdk-openjdk

# Enable Docker service if installed
if package_installed docker; then
  echo "Enabling Docker service..."
  sudo systemctl enable --now docker.service
  
  # Add current user to docker group if not already
  if ! groups | grep -q docker; then
    sudo usermod -aG docker "$USER"
    echo "Added $USER to docker group. You'll need to log out and back in for this to take effect."
  fi
fi

##
# Desktop
#

print_header "Desktop Applications"

# Function to install a group of packages
install_group() {
  local group_name="$1"
  shift
  local packages=("$@")
  
  echo "Installing $group_name..."
  yay -Sy --needed --noconfirm "${packages[@]}"
}

# Browsers
echo "Setting up browsers..."
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
install_group "Browsers" brave-bin firefox tor-browser-bin chromium

# Communication
install_group "Communication Tools" thunderbird thunderbird-i18n-pt-br hunspell-en_us hunspell-pt-br zoom

# Fonts
install_group "Fonts" ttf-opensans ttf-ubuntu-font-family ttf-bitstream-vera ttf-liberation noto-fonts ttf-ms-fonts ttf-caladea ttf-carlito ttf-dejavu ttf-gentium-basic ttf-linux-libertine-g adobe-source-code-pro-fonts adobe-source-sans-fonts adobe-source-serif-fonts noto-fonts-emoji

# Games
install_group "Games" minecraft-launcher

# i3 Window Manager and related tools
install_group "i3 Window Manager" polybar picom rofi maim i3lock-color brightnessctl cava rofi-calc

# Theme and Icons
install_group "Themes and Icons" papirus-icon-theme

# Utility Applications
install_group "Utility Applications" logseq-desktop-bin anki-bin rnote xournalpp texlive-latex texlive-latexrecommended texlive-latexextra keepassxc transmission-gtk localsend-bin

# Keyboard
install_group "Keyboard" kbd-br-thinkpad

# Media and Creative Applications
install_group "Media and Creative Applications" inkscape gimp blender audacity obs-studio v4l2loopback-dkms obs-source-clone obs-move-transition handbrake vlc yt-dlp metadata-cleaner

# Update font cache
echo "Updating font cache..."
fc-cache -f

##
# System Configuration
#

print_header "System Configuration"

# Function to enable and start a service
setup_service() {
  local service_name="$1"
  echo "Setting up $service_name service..."
  sudo systemctl enable --now "$service_name.service"
}

# Bluetooth
echo "Configuring Bluetooth..."
setup_service bluetooth

# CUPS (Printing)
echo "Setting up printing system..."
install_group "Printing" cups brother-hl1210w
setup_service cups

# Ask for printer IP address or use default
read -p "Enter Brother printer IP address [192.168.15.84]: " PRINTER_IP
PRINTER_IP=${PRINTER_IP:-192.168.15.84}

echo "Adding Brother printer at $PRINTER_IP..."
sudo lpadmin -p Brother-HL-1212W -E -v "ipp://$PRINTER_IP" -m brother-HL1210W-cups-en.ppd -o media=iso_a4_210x297mm

# UFW (Firewall)
echo "Configuring firewall (UFW)..."

# Create LocalSend application definition
sudo bash -c 'cat > /etc/ufw/applications.d/localsend << EOF
[LocalSend]
title=LocalSend
description=An open-source cross-platform alternative to AirDrop
ports=53317
EOF'

sudo ufw app update LocalSend
sudo ufw allow localsend

# Ask before enabling firewall
read -p "Enable firewall with default deny policy? (y/n): " ENABLE_UFW
if [[ "$ENABLE_UFW" =~ ^[Yy]$ ]]; then
  sudo ufw default deny
  setup_service ufw
  echo "Firewall enabled with default deny policy."
else
  echo "Firewall setup skipped."
fi

##
# Cleanup
#

print_header "Cleanup"

# Remove unused Go directory if it exists
if [ -d "$HOME/go" ]; then
  echo "Removing unused Go directory..."
  rm -rf "$HOME/go"
fi

# Remove orphaned packages
echo "Removing orphaned packages..."
orphans=$(pacman -Qdtq)
if [ -n "$orphans" ]; then
  echo "$orphans" | sudo pacman -Rns --noconfirm -
else
  echo "No orphaned packages found."
fi

# Clean package cache
echo "Cleaning package cache..."
yay -Scc --noconfirm

print_header "Setup Complete!"
echo "Your system has been configured successfully."
echo "Please log out and log back in for all changes to take effect."
