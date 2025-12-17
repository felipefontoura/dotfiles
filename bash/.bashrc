# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#

# Load envs
if [ -f ~/.env ]; then
  source ~/.env
fi

# Load aliases
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi
