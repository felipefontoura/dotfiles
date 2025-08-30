# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Load envs
if [ -f ~/.env ]; then
  source ~/.env
fi

# Load aliases
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"

# Load Spartship (at EOF)
eval "$(starship init bash)"
