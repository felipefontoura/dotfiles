#!/usr/bin/env bash

# Reference: omakub.org

# Exit on error, undefined variables, and propagate pipe errors
set -euo pipefail

#######################################
# CONFIGURATION
#######################################

# Language versions
NODEJS_VERSION="22.13.1"
RUBY_VERSION="3.4.1"
PYTHON_VERSION="3.13.2"

# Default printer IP
PRINTER_IP="192.168.15.84"

# Enable firewall by default
ENABLE_FIREWALL=false

# Development directory
DEV_DIR="$HOME/Development"

#######################################
# INITIALIZATION
#######################################

# Enable debug mode if requested
if [[ "${DEBUG:-false}" == "true" ]]; then
  set -x
fi

# Parse command line arguments
parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in

    --printer=*)
      PRINTER_IP="${1#*=}"
      shift
      ;;
    --firewall)
      ENABLE_FIREWALL=true
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
    esac
  done

}

show_help() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:

  --printer=IP        Set printer IP address
  --firewall          Enable firewall with default deny policy
  --help              Show this help message

Example:
  $0 --printer=192.168.1.100 --firewall
EOF
}

#######################################
# UTILITY FUNCTIONS
#######################################

# Logging functions
print_header() {
  echo -e "\n\033[1;34m## $1\033[0m"
}

print_success() {
  echo -e "\033[1;32m✓ $1\033[0m"
}

print_error() {
  echo -e "\033[1;31m✗ $1\033[0m" >&2
}

print_warning() {
  echo -e "\033[1;33m! $1\033[0m"
}

print_info() {
  echo -e "\033[1;36m→ $1\033[0m"
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >>"$HOME/.setup_log.txt"
}

# System check functions
command_exists() {
  type "$1" &>/dev/null
}

package_installed() {
  pacman -Q "$1" &>/dev/null
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
    print_warning "Creating backup of $file to $backup"
    cp "$file" "$backup"
    log "Created backup of $file to $backup"
  fi
}

check_sudo() {
  if [[ $EUID -ne 0 ]]; then
    print_error "This operation requires root privileges. Please run with sudo."
    return 1
  fi
  return 0
}

# Package management functions
install_group() {
  local group_name="$1"
  shift
  local packages=("$@")

  print_info "Installing $group_name..."
  log "Installing packages: ${packages[*]}"
  yay -Sy --needed --noconfirm "${packages[@]}" && {
    print_success "$group_name installed successfully"
  } || {
    print_error "Failed to install some $group_name packages"
    log "Failed to install some packages: ${packages[*]}"
  }
}

uninstall_group() {
  local group_name="$1"
  shift
  local packages=("$@")

  print_info "Removing $group_name..."
  log "Removing packages: ${packages[*]}"
  sudo pacman -Rs --noconfirm "${packages[@]}" 2>/dev/null || true
}

# Service management
setup_service() {
  local service_name="$1"
  print_info "Setting up $service_name service..."
  sudo systemctl enable --now "$service_name.service" && {
    print_success "$service_name service enabled and started"
    log "$service_name service enabled and started"
  } || {
    print_error "Failed to enable/start $service_name service"
    log "Failed to enable/start $service_name service"
  }
}

#######################################
# PACKAGE MANAGER SETUP
#######################################

setup_package_manager() {
  print_header "Package Manager Setup"

  if command_exists yay; then
    print_success "YAY is already installed, skipping..."
  else
    print_info "Installing YAY..."
    sudo pacman -S --needed --noconfirm git base-devel || {
      print_error "Failed to install git and base-devel"
      exit 1
    }

    # Clean up any previous failed attempts
    rm -rf ~/yay-bin

    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin || {
      print_error "Failed to clone yay-bin repository"
      exit 1
    }

    (cd ~/yay-bin && makepkg -si --noconfirm) || {
      print_error "Failed to build and install yay"
      exit 1
    }

    rm -rf ~/yay-bin
    print_success "YAY installed successfully"
    log "YAY installed successfully"
  fi
}

#######################################
# SHELL SETUP
#######################################

setup_shell() {
  print_header "Shell and Utils"

  # Install shell utilities
  local shell_utils=(
    fzf bat eza zoxide plocate fd tldr zsh ripgrep procs grex btop dust tmux
    superfile-bin stow ufw curl usbutils pwgen wmctrl dosfstools exfatprogs
    ntfs-3g f2fs-tools p7zip rar zip unzip rsync rclone man-db man-pages
    fastfetch zsh-theme-powerlevel10k ttf-ibmplex-mono-nerd
  )
  install_group "Shell Utilities" "${shell_utils[@]}"

  # Setup ZSH
  setup_zsh

  # Setup TMUX
  setup_tmux
}

setup_zsh() {
  print_info "Setting up ZSH..."

  # ZSH plugins
  ZSH_PLUGINS_DIR="$HOME/.zsh"
  mkdir -p "$ZSH_PLUGINS_DIR"

  # Install ZSH plugins if not already installed
  local zsh_plugins=(
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "zsh-history-substring-search:https://github.com/zsh-users/zsh-history-substring-search"
  )

  for plugin in "${zsh_plugins[@]}"; do
    local plugin_name="${plugin%%:*}"
    local plugin_url="${plugin#*:}"

    if [ ! -d "$ZSH_PLUGINS_DIR/$plugin_name" ]; then
      print_info "Installing ZSH plugin: $plugin_name"
      git clone "$plugin_url" "$ZSH_PLUGINS_DIR/$plugin_name" && {
        print_success "Installed ZSH plugin: $plugin_name"
        log "Installed ZSH plugin: $plugin_name"
      } || {
        print_error "Failed to install ZSH plugin: $plugin_name"
        log "Failed to install ZSH plugin: $plugin_name"
      }
    else
      print_success "ZSH plugin already installed: $plugin_name"
    fi
  done

  # Change shell to ZSH if not already
  if [ "$SHELL" != "/usr/bin/zsh" ]; then
    print_info "Changing default shell to ZSH..."
    chsh -s /usr/bin/zsh && {
      print_success "Default shell changed to ZSH"
      log "Default shell changed to ZSH"
    } || {
      print_error "Failed to change default shell to ZSH"
      log "Failed to change default shell to ZSH"
    }
  else
    print_success "ZSH is already the default shell"
  fi
}

setup_tmux() {
  print_info "Setting up TMUX..."

  # TMUX plugins
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_info "Installing TMUX plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" && {
      print_success "TMUX plugin manager installed"
      log "TMUX plugin manager installed"
    } || {
      print_error "Failed to install TMUX plugin manager"
      log "Failed to install TMUX plugin manager"
    }
  else
    print_success "TMUX plugin manager already installed"
  fi
}

#######################################
# DOTFILES SETUP
#######################################

setup_dotfiles() {
  print_header "Dotfiles"

  DOTFILES_DIR="$HOME/.dotfiles"

  if [ -d "$DOTFILES_DIR" ]; then
    print_info "Dotfiles directory already exists, updating..."
    (cd "$DOTFILES_DIR" && git pull) && {
      print_success "Dotfiles updated successfully"
      log "Dotfiles updated successfully"
    } || {
      print_error "Failed to update dotfiles"
      log "Failed to update dotfiles"
    }
  else
    print_info "Cloning dotfiles..."
    git clone https://github.com/felipefontoura/dotfiles.git "$DOTFILES_DIR" && {
      print_success "Dotfiles cloned successfully"
      log "Dotfiles cloned successfully"
    } || {
      print_error "Failed to clone dotfiles"
      log "Failed to clone dotfiles"
      return 1
    }
  fi

  # Define base configs
  local configs=(
    "alacritty"
    "asdf"
    "btop"
    "fastfetch"
    "git"
    "gtk"
    "nvim"
    "p10k"
    "ruby"
    "tmux"
    "ulauncher"
    "zsh"
  )

  print_info "Stowing configuration files..."
  cd "$DOTFILES_DIR" || return 1

  for config in "${configs[@]}"; do
    print_info "Stowing $config..."
    stow -R "$config" && {
      print_success "Stowed $config successfully"
      log "Stowed $config successfully"
    } || {
      print_error "Failed to stow $config"
      log "Failed to stow $config"
    }
  done
}

#######################################
# DEVELOPMENT ENVIRONMENT SETUP
#######################################

setup_development() {
  print_header "Development Environment"

  # Setup version manager
  setup_asdf

  # Setup programming languages
  setup_languages

  # Setup development tools
  setup_dev_tools

  # Setup Docker
  setup_docker

  # Create development directory
  mkdir -p "$DEV_DIR" && {
    print_success "Created development directory: $DEV_DIR"
    log "Created development directory: $DEV_DIR"
  }
}

setup_asdf() {
  print_info "Setting up ASDF version manager..."

  # Install ASDF if not already installed
  if ! command_exists asdf; then
    print_info "Installing ASDF version manager..."
    yay -Sy --needed --noconfirm asdf-vm && {
      print_success "ASDF installed successfully"
      log "ASDF installed successfully"
    } || {
      print_error "Failed to install ASDF"
      log "Failed to install ASDF"
      return 1
    }

    # Source ASDF to make it available in this script
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  else
    print_success "ASDF already installed"
  fi

  # Setup ASDF completions
  mkdir -p "$HOME/.asdf/completions"
  asdf completion zsh >"$HOME/.asdf/completions/_asdf" && {
    print_success "ASDF completions setup successfully"
    log "ASDF completions setup successfully"
  }

  # Install ASDF plugins
  print_info "Setting up ASDF plugins..."
  local asdf_plugins=(
    "nodejs:https://github.com/asdf-vm/asdf-nodejs.git"
    "ruby:https://github.com/asdf-vm/asdf-ruby.git"
    "python:https://github.com/asdf-community/asdf-python"
  )

  for plugin_entry in "${asdf_plugins[@]}"; do
    local plugin_name="${plugin_entry%%:*}"
    local plugin_url="${plugin_entry#*:}"

    if ! asdf plugin list 2>/dev/null | grep -q "$plugin_name"; then
      print_info "Adding ASDF plugin: $plugin_name"
      asdf plugin add "$plugin_name" "$plugin_url" && {
        print_success "Added ASDF plugin: $plugin_name"
        log "Added ASDF plugin: $plugin_name"
      } || {
        print_error "Failed to add ASDF plugin: $plugin_name"
        log "Failed to add ASDF plugin: $plugin_name"
      }
    else
      print_info "ASDF plugin $plugin_name already installed, updating..."
      asdf plugin update "$plugin_name" && {
        print_success "Updated ASDF plugin: $plugin_name"
        log "Updated ASDF plugin: $plugin_name"
      } || {
        print_warning "Failed to update ASDF plugin: $plugin_name"
        log "Failed to update ASDF plugin: $plugin_name"
      }
    fi
  done
}

setup_languages() {
  print_info "Setting up programming languages..."

  # Install language versions with ASDF
  print_info "Installing language versions with ASDF..."

  # Install and set global versions
  install_asdf_version nodejs "$NODEJS_VERSION"
  install_asdf_version ruby "$RUBY_VERSION"
  install_asdf_version python "$PYTHON_VERSION"

  # Ruby on Rails dependencies
  print_info "Installing Ruby on Rails dependencies..."
  yay -Sy --needed --noconfirm libvips imagemagick graphicsmagick postgresql-libs libpqxx pgcli sqlite3 && {
    print_success "Ruby on Rails dependencies installed"
    log "Ruby on Rails dependencies installed"
  }

  # Nodejs global packages
  print_info "Installing global NPM packages..."
  if [[ -f "$HOME/.asdf/shims/npm" ]]; then
    "$HOME/.asdf/shims/npm" install -g yarn neovim && {
      print_success "Global NPM packages installed"
      log "Global NPM packages installed"
    } || {
      print_error "Failed to install global NPM packages"
      log "Failed to install global NPM packages"
    }
  else
    print_error "NPM not found, skipping global package installation"
    log "NPM not found, skipping global package installation"
  fi
}

# Helper function for ASDF version installation
install_asdf_version() {
  local lang="$1"
  local version="$2"
  print_info "Installing $lang $version..."
  asdf install "$lang" "$version" && {
    asdf set "$lang" "$version" --default && {
      print_success "$lang $version installed and set as global"
      log "$lang $version installed and set as global"
    } || {
      print_warning "Failed to set global $lang $version"
      log "Failed to set global $lang $version"
    }
  } || {
    print_warning "Failed to install $lang $version"
    log "Failed to install $lang $version"
  }
}

setup_dev_tools() {
  print_info "Setting up development tools..."

  # Install development tools
  local dev_tools=(
    docker docker-buildx lazydocker-bin lazygit neovim neovim-notify
    wl-clipboard xsel xclip tree-sitter-cli harper jdk-openjdk
  )
  install_group "Development Tools" "${dev_tools[@]}"
}

setup_docker() {
  print_info "Setting up Docker..."

  # Enable Docker service if installed
  if package_installed docker; then
    print_info "Enabling Docker service..."
    sudo systemctl enable --now docker.service && {
      print_success "Docker service enabled and started"
      log "Docker service enabled and started"
    } || {
      print_error "Failed to enable Docker service"
      log "Failed to enable Docker service"
    }

    # Add current user to docker group if not already
    if ! groups | grep -q docker; then
      print_info "Adding $USER to docker group..."
      sudo usermod -aG docker "$USER" && {
        print_success "Added $USER to docker group"
        log "Added $USER to docker group"
        print_warning "You'll need to log out and back in for this to take effect"
      } || {
        print_error "Failed to add $USER to docker group"
        log "Failed to add $USER to docker group"
      }
    else
      print_success "User already in docker group"
    fi
  else
    print_warning "Docker not installed, skipping service setup"
    log "Docker not installed, skipping service setup"
  fi
}

#######################################
# DESKTOP APPLICATIONS SETUP
#######################################

setup_desktop_applications() {
  print_header "Desktop Applications"

  # Install browsers
  setup_browsers

  # Install communication tools
  setup_communication_tools

  # Install fonts
  setup_fonts

  # Install games
  setup_games

  # Install desktop environment specific applications
  setup_desktop_environment

  # Install themes and icons
  setup_themes

  # Install utility applications
  setup_utility_applications

  # Install keyboard utilities
  setup_keyboard

  # Install media and creative applications
  setup_media_applications

  # Update font cache
  print_info "Updating font cache..."
  fc-cache -f && {
    print_success "Font cache updated"
    log "Font cache updated"
  } || {
    print_warning "Failed to update font cache"
    log "Failed to update font cache"
  }
}

setup_browsers() {
  print_info "Setting up browsers..."

  # Uncomment if you want to install Tor Browser
  # gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org

  local browsers=(
    brave-bin
    firefox
    chromium
    # tor-browser-bin  # Uncomment to install Tor Browser
  )
  install_group "Browsers" "${browsers[@]}"
}

setup_communication_tools() {
  local communication_tools=(
    thunderbird
    thunderbird-i18n-pt-br
    hunspell-en_us
    hunspell-pt-br
    zoom
  )
  install_group "Communication Tools" "${communication_tools[@]}"
}

setup_fonts() {
  local fonts=(
    ttf-opensans
    ttf-ubuntu-font-family
    ttf-bitstream-vera
    ttf-liberation
    noto-fonts
    ttf-ms-fonts
    ttf-caladea
    ttf-carlito
    ttf-dejavu
    ttf-gentium-basic
    ttf-linux-libertine-g
    adobe-source-code-pro-fonts
    adobe-source-sans-fonts
    adobe-source-serif-fonts
    noto-fonts-emoji
  )
  install_group "Fonts" "${fonts[@]}"
}

setup_games() {
  local games=(
    minecraft-launcher
  )
  install_group "Games" "${games[@]}"
}

setup_desktop_environment() {
  setup_gnome_environment
}

setup_gnome_environment() {
  local gnome_packages=(
    gnome-boxes
    sushi
    ulauncher
    flameshot
  )
  install_group "GNOME Desktop" "${gnome_packages[@]}"

  local unwanted_gnome_apps=(
    totem
    gnome-music
    gnome-weather
    gnome-maps
    gnome-tour
    gnome-software
    gnome-contacts
    snapshot
    gnome-clocks
    yelp
    epiphany
    gnome-calendar
    gnome-logs
    gnome-user-docs
  )
  uninstall_group "Unwanted GNOME Applications" "${unwanted_gnome_apps[@]}"

  # Install GNOME themes
  local gnome_themes=(
    yaru-gtk-theme
    yaru-gnome-shell-theme
  )
  install_group "GNOME Themes" "${gnome_themes[@]}"
}

setup_themes() {
  local themes=(
    papirus-icon-theme
    papirus-folders
  )
  install_group "Themes and Icons" "${themes[@]}"
}

setup_utility_applications() {
  local utility_apps=(
    alacritty
    logseq-desktop-bin
    anki-bin
    rnote
    xournalpp
    texlive-latex
    texlive-latexrecommended
    texlive-latexextra
    keepassxc
    transmission-gtk
    localsend-bin
  )
  install_group "Utility Applications" "${utility_apps[@]}"
}

setup_keyboard() {
  local keyboard_packages=(
    kbd-br-thinkpad
  )
  install_group "Keyboard" "${keyboard_packages[@]}"
}

setup_media_applications() {
  local media_apps=(
    inkscape
    gimp
    blender
    audacity
    obs-studio
    v4l2loopback-dkms
    obs-source-clone
    obs-move-transition
    handbrake
    vlc
    yt-dlp
    metadata-cleaner
  )
  install_group "Media and Creative Applications" "${media_apps[@]}"
}

#######################################
# SYSTEM CONFIGURATION
#######################################

setup_system() {
  print_header "System Configuration"

  # Configure NVIDIA GPU if present
  setup_nvidia

  # Configure Bluetooth
  setup_bluetooth

  # Configure printing
  setup_printing

  # Configure firewall
  setup_firewall
}

setup_nvidia() {
  print_info "Checking for NVIDIA GPU..."
  if lspci | grep -i nvidia &>/dev/null; then
    print_info "NVIDIA GPU detected, configuring as primary GPU..."

    # Create directory if it doesn't exist
    sudo mkdir -p /etc/X11/xorg.conf.d

    # Backup existing config if it exists
    if [[ -f "/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf" ]]; then
      backup_file "/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"
    fi

    # Create NVIDIA configuration file
    sudo bash -c 'cat > /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf << EOF
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
EOF'

    print_success "NVIDIA GPU configured as primary GPU."
    log "NVIDIA GPU configured as primary GPU"

    # Install NVIDIA drivers if not already installed
    if ! package_installed nvidia; then
      print_info "Installing NVIDIA drivers..."
      yay -Sy --needed --noconfirm nvidia nvidia-utils nvidia-settings && {
        print_success "NVIDIA drivers installed"
        log "NVIDIA drivers installed"
      } || {
        print_error "Failed to install NVIDIA drivers"
        log "Failed to install NVIDIA drivers"
      }
    else
      print_success "NVIDIA drivers already installed"
    fi
  else
    print_warning "No NVIDIA GPU detected, skipping configuration."
    log "No NVIDIA GPU detected, skipping configuration"
  fi
}

setup_bluetooth() {
  print_info "Configuring Bluetooth..."
  setup_service bluetooth
}

setup_printing() {
  print_info "Setting up printing system..."

  # Install printing packages
  local printing_packages=(
    cups
    brother-hl1210w
  )
  install_group "Printing" "${printing_packages[@]}"

  # Enable CUPS service
  setup_service cups

  # Configure printer
  setup_brother_printer
}

setup_brother_printer() {
  # Use the printer IP from configuration or ask for it
  if [[ -z "$PRINTER_IP" ]]; then
    read -p "Enter Brother printer IP address [192.168.15.84]: " PRINTER_IP
    PRINTER_IP=${PRINTER_IP:-192.168.15.84}
  fi

  print_info "Adding Brother printer at $PRINTER_IP..."
  if command_exists lpadmin; then
    # Check if the PPD file exists
    if [[ -f "/usr/share/cups/model/brother-HL1210W-cups-en.ppd" ]]; then
      sudo lpadmin -p Brother-HL-1212W -E -v "ipp://$PRINTER_IP" -m brother-HL1210W-cups-en.ppd -o media=iso_a4_210x297mm && {
        print_success "Brother printer added successfully"
        log "Brother printer added successfully at $PRINTER_IP"
      } || {
        print_error "Failed to add Brother printer"
        log "Failed to add Brother printer at $PRINTER_IP"
      }
    else
      # Try to find the PPD file
      PPD_PATH=$(find /usr/share/cups/model -name "*HL1210W*.ppd" -o -name "*HL-1210W*.ppd" | head -n 1)
      if [[ -n "$PPD_PATH" ]]; then
        sudo lpadmin -p Brother-HL-1212W -E -v "ipp://$PRINTER_IP" -m "$PPD_PATH" -o media=iso_a4_210x297mm && {
          print_success "Brother printer added successfully using $PPD_PATH"
          log "Brother printer added successfully at $PRINTER_IP using $PPD_PATH"
        } || {
          print_error "Failed to add Brother printer"
          log "Failed to add Brother printer at $PRINTER_IP"
        }
      else
        print_error "Brother printer PPD file not found. Please install the driver first."
        log "Brother printer PPD file not found"
      fi
    fi
  else
    print_error "lpadmin command not found. Make sure CUPS is installed properly."
    log "lpadmin command not found"
  fi
}

setup_firewall() {
  print_info "Configuring firewall (UFW)..."

  # Create LocalSend application definition
  sudo bash -c 'cat > /etc/ufw/applications.d/localsend << EOF
[LocalSend]
title=LocalSend
description=An open-source cross-platform alternative to AirDrop
ports=53317
EOF'

  sudo ufw app update LocalSend && {
    print_success "LocalSend application defined in UFW"
    log "LocalSend application defined in UFW"
  }

  sudo ufw allow localsend && {
    print_success "LocalSend allowed in firewall"
    log "LocalSend allowed in firewall"
  }

  # Enable firewall if configured to do so
  if [[ "$ENABLE_FIREWALL" == "true" ]]; then
    print_info "Enabling firewall with default deny policy..."
    sudo ufw default deny && {
      setup_service ufw
      print_success "Firewall enabled with default deny policy"
      log "Firewall enabled with default deny policy"
    } || {
      print_error "Failed to configure firewall"
      log "Failed to configure firewall"
    }
  else
    if [[ -z "$ENABLE_FIREWALL" ]]; then
      read -p "Enable firewall with default deny policy? (y/n): " ENABLE_UFW
      if [[ "$ENABLE_UFW" =~ ^[Yy]$ ]]; then
        sudo ufw default deny
        setup_service ufw
        print_success "Firewall enabled with default deny policy"
        log "Firewall enabled with default deny policy"
      else
        print_info "Firewall setup skipped"
        log "Firewall setup skipped"
      fi
    else
      print_info "Firewall setup skipped (disabled in configuration)"
      log "Firewall setup skipped (disabled in configuration)"
    fi
  fi
}

#######################################
# GNOME CUSTOMIZATION
#######################################

setup_gnome_customization() {
  print_header "GNOME Customization"

  # Install and configure extensions
  setup_gnome_extensions

  # Configure GNOME appearance
  setup_gnome_appearance

  # Configure GNOME behavior
  setup_gnome_behavior

  # Configure GNOME keybindings
  setup_gnome_keybindings
}

setup_gnome_extensions() {
  print_info "Setting up GNOME extensions..."

  # Install GNOME extensions CLI
  install_group "Extensions" gnome-extensions-cli

  # Define extensions to install
  local extensions=(
    "tactile@lundal.io"
    "just-perfection-desktop@just-perfection"
    "blur-my-shell@aunetx"
    "space-bar@luchrioh"
    "undecorate@sun.wxg@gmail.com"
    "tophat@fflewddur.github.io"
    "AlphabeticalAppGrid@stuarthayhurst"
  )

  # Install extensions
  for ext in "${extensions[@]}"; do
    print_info "Installing GNOME extension: $ext"
    gext install "$ext" && {
      print_success "Installed GNOME extension: $ext"
      log "Installed GNOME extension: $ext"
    } || {
      print_error "Failed to install GNOME extension: $ext"
      log "Failed to install GNOME extension: $ext"
    }
  done

  # Compile gsettings schemas
  print_info "Compiling gsettings schemas..."

  # Map of extension IDs to schema files
  declare -A schema_files=(
    ["tactile@lundal.io"]="org.gnome.shell.extensions.tactile.gschema.xml"
    ["just-perfection-desktop@just-perfection"]="org.gnome.shell.extensions.just-perfection.gschema.xml"
    ["blur-my-shell@aunetx"]="org.gnome.shell.extensions.blur-my-shell.gschema.xml"
    ["space-bar@luchrioh"]="org.gnome.shell.extensions.space-bar.gschema.xml"
    ["tophat@fflewddur.github.io"]="org.gnome.shell.extensions.tophat.gschema.xml"
    ["AlphabeticalAppGrid@stuarthayhurst"]="org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml"
  )

  # Copy schema files and compile them
  for ext_id in "${!schema_files[@]}"; do
    local schema_file="${schema_files[$ext_id]}"
    local ext_path="$HOME/.local/share/gnome-shell/extensions/$ext_id"

    if [[ -f "$ext_path/schemas/$schema_file" ]]; then
      sudo cp "$ext_path/schemas/$schema_file" /usr/share/glib-2.0/schemas/ && {
        print_success "Copied schema for $ext_id"
        log "Copied schema for $ext_id"
      } || {
        print_error "Failed to copy schema for $ext_id"
        log "Failed to copy schema for $ext_id"
      }
    else
      print_warning "Schema file not found for $ext_id"
      log "Schema file not found for $ext_id"
    fi
  done

  # Compile schemas
  sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ && {
    print_success "Compiled gsettings schemas"
    log "Compiled gsettings schemas"
  } || {
    print_error "Failed to compile gsettings schemas"
    log "Failed to compile gsettings schemas"
  }

  # Configure extensions
  configure_gnome_extensions
}

configure_gnome_extensions() {
  print_info "Configuring GNOME extensions..."

  # Configure Tactile
  print_info "Configuring Tactile extension..."
  gsettings set org.gnome.shell.extensions.tactile col-0 1
  gsettings set org.gnome.shell.extensions.tactile col-1 2
  gsettings set org.gnome.shell.extensions.tactile col-2 1
  gsettings set org.gnome.shell.extensions.tactile col-3 0
  gsettings set org.gnome.shell.extensions.tactile row-0 1
  gsettings set org.gnome.shell.extensions.tactile row-1 1
  gsettings set org.gnome.shell.extensions.tactile gap-size 32

  # Configure Just Perfection
  print_info "Configuring Just Perfection extension..."
  gsettings set org.gnome.shell.extensions.just-perfection animation 2
  gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
  gsettings set org.gnome.shell.extensions.just-perfection workspace true
  gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

  # Configure Blur My Shell
  print_info "Configuring Blur My Shell extension..."
  gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
  gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
  gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
  gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
  gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
  gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
  gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
  gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
  gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
  gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
  gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
  gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

  # Configure Space Bar
  print_info "Configuring Space Bar extension..."
  gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
  gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

  # Configure TopHat
  print_info "Configuring TopHat extension..."
  gsettings set org.gnome.shell.extensions.tophat show-icons false
  gsettings set org.gnome.shell.extensions.tophat show-cpu false
  gsettings set org.gnome.shell.extensions.tophat show-disk false
  gsettings set org.gnome.shell.extensions.tophat show-mem false
  gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

  # Configure AlphabeticalAppGrid
  print_info "Configuring AlphabeticalAppGrid extension..."
  gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

  print_success "GNOME extensions configured"
  log "GNOME extensions configured"
}

setup_gnome_appearance() {
  print_info "Configuring GNOME appearance..."

  # Setting theme
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
  gsettings set org.gnome.desktop.interface gtk-theme "Yaru-magenta-dark"
  gsettings set org.gnome.shell.extensions.user-theme name "Yaru-magenta-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Papirus"
  gsettings set org.gnome.desktop.interface accent-color 'purple'

  # Folder colors
  papirus-folders -C magenta --theme Papirus-Dark && {
    print_success "Papirus folder colors set to magenta"
    log "Papirus folder colors set to magenta"
  } || {
    print_warning "Failed to set Papirus folder colors"
    log "Failed to set Papirus folder colors"
  }

  # Set monospace font
  gsettings set org.gnome.desktop.interface monospace-font-name 'BlexMono Nerd Font Medium 12'

  print_success "GNOME appearance configured"
  log "GNOME appearance configured"
}

setup_gnome_behavior() {
  print_info "Configuring GNOME behavior..."

  # Center new windows
  gsettings set org.gnome.mutter center-new-windows true

  # Calendar settings
  gsettings set org.gnome.desktop.calendar show-weekdate true
  gsettings set org.gnome.desktop.calendar clock-show-weekday true
  gsettings set org.gnome.desktop.calendar clock-format '24h'

  # Battery percentage
  gsettings set org.gnome.desktop.interface show-battery-percentage true

  print_success "GNOME behavior configured"
  log "GNOME behavior configured"
}

setup_gnome_keybindings() {
  print_info "Configuring GNOME keybindings..."

  # Window management
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
  gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
  gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

  # Media keys
  gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"

  # Workspace configuration
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

  # Workspace switching
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

  # Application switching
  gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
  gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
  gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
  gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
  gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
  gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
  gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
  gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
  gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

  # Disable input source switching
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"

  # Custom keybindings
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

  # Ulauncher
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'ulauncher-toggle'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ulauncher-toggle'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>space'

  # Flameshot
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'

  # New Alacritty window
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'alacritty'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'alacritty'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Shift><Alt>2'

  # New Brave window
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'new brave'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'brave'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Shift><Alt>1'

  print_success "GNOME keybindings configured"
  log "GNOME keybindings configured"

}

#######################################
# CLEANUP
#######################################

cleanup_system() {
  print_header "Cleanup"

  # Remove unused directories
  cleanup_directories

  # Remove orphaned packages
  cleanup_packages

  # Clean package cache
  cleanup_cache
}

cleanup_directories() {
  # Remove unused Go directory if it exists
  if [ -d "$HOME/go" ]; then
    print_info "Removing unused Go directory..."
    rm -rf "$HOME/go" && {
      print_success "Removed unused Go directory"
      log "Removed unused Go directory"
    } || {
      print_warning "Failed to remove Go directory"
      log "Failed to remove Go directory"
    }
  fi
}

cleanup_packages() {
  print_info "Removing orphaned packages..."
  orphans=$(pacman -Qdtq 2>/dev/null)
  if [ -n "$orphans" ]; then
    echo "$orphans" | sudo pacman -Rns --noconfirm - && {
      print_success "Removed orphaned packages"
      log "Removed orphaned packages"
    } || {
      print_warning "Failed to remove some orphaned packages"
      log "Failed to remove some orphaned packages"
    }
  else
    print_success "No orphaned packages found"
    log "No orphaned packages found"
  fi
}

cleanup_cache() {
  print_info "Cleaning package cache..."
  yay -Scc --noconfirm && {
    print_success "Package cache cleaned"
    log "Package cache cleaned"
  } || {
    print_warning "Failed to clean package cache"
    log "Failed to clean package cache"
  }
}

#######################################
# COMPLETION
#######################################

show_completion_message() {
  print_header "Setup Complete!"
  echo "Your system has been configured successfully with GNOME desktop environment."
  echo "Please log out and log back in for all changes to take effect."

  # Display additional information
  echo -e "\n\033[1;32mSummary:\033[0m"
  echo "- Desktop Environment: GNOME"
  echo "- Node.js: $NODEJS_VERSION"
  echo "- Ruby: $RUBY_VERSION"
  echo "- Python: $PYTHON_VERSION"

  # Display GNOME tips
  echo -e "\n\033[1;33mGNOME Tips:\033[0m"
  echo "- Use Super+1-6 to switch workspaces"
  echo "- Extensions have been configured automatically"
  echo "- Yaru Magenta theme has been applied"

  echo -e "\n\033[1;36mEnjoy your newly configured system!\033[0m"

  # Log completion
  log "Setup completed successfully with GNOME desktop environment"
}

#######################################
# MAIN EXECUTION
#######################################

main() {
  # Parse command line arguments
  parse_arguments "$@"

  # Display script header
  print_header "Arch Linux Post-Installation Setup"
  print_info "Starting GNOME setup"

  # Setup pacman and AUR helper
  setup_package_manager

  # Setup shell environment
  setup_shell

  # Setup dotfiles
  setup_dotfiles

  # Setup development environment
  setup_development

  # Setup desktop applications
  setup_desktop_applications

  # Setup system configuration
  setup_system

  # Setup GNOME customizations
  setup_gnome_customization

  # Final cleanup
  cleanup_system

  # Show completion message
  show_completion_message
}

# Execute main function with all script arguments
main "$@"
