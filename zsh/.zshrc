# Exec fastfetch
fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize autocompletion
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/felipefontoura/.zshrc'
autoload -Uz compinit
compinit

# History setup
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

bindkey -v

# Autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Home, End, Insert and Delete keys
bindkey  "^[[H"  beginning-of-line
bindkey  "^[[F"  end-of-line
bindkey  "^[[3~" delete-char
bindkey  "^H"    backward-delete-word

# No beep
setopt NO_BEEP

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

source /opt/asdf-vm/asdf.sh

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Export ENV
[[ ! -f ~/.env ]] || source ~/.env

# Git
alias g="git"
alias gcl="git clone"
alias gck="git checkout"
alias gst="git status"
alias gdf="git diff"
alias gad="git add"
alias gcm="git commit"
alias gpl="git pull"
alias gps="git push"
alias grb="git rebase"

# Rails
alias rce="bin/rails credentials:edit"
alias rcs="bin/rails credentials:show"

alias rgmi="bin/rails generate migration"
alias rdmi="bin/rails destroy migration"
alias rgmd="bin/rails generate model"
alias rdmd="bin/rails destroy model"
alias rgct="bin/rails generate controller"
alias rdct="bin/rails destroy controller"
alias rghp="bin/rails generate helper"
alias rdhp="bin/rails destroy helper"
alias rgjb="bin/rails generate job"
alias rdjb="bin/rails destroy job"
alias rgat="bin/rails generate authentication"
alias rdat="bin/rails destroy authentication"

alias rc="bin/rails console"
alias rr="bin/rails routes"

alias rt="bin/rails test"
alias rtm="bin/rails test:models"
alias rtc="bin/rails test:controllers"
alias rth="bin/rails test:helpers"
alias rts="bin/rails test:system"
alias rta="bin/rails test:all"

alias rdbst="bin/rails db:setup"
alias rdbcr="bin/rails db:create"
alias rdbmi="bin/rails db:migrate"
alias rdbrb="bin/rails db:rollback"
alias rdbsd="bin/rails db:seed"

alias fsd="bundle exec foreman start -f Procfile.dev"
alias fsp="bundle exec foreman start -f Procfile"

# Bundle
alias bi="bundle install"
alias be="bundle exec"

# Kamal
alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${HOME}/.ssh/id_rsa:/root/.ssh/id_rsa" -v /var/run/docker.sock:/var/run/docker.sock -e KAMAL_REGISTRY_PASSWORD=$(env | grep "^KAMAL_" | cut -d '=' -f2) ghcr.io/basecamp/kamal:latest'

# Neovim
alias n="nvim"
alias n.="nvim ."

# File manager
alias rg="ranger"
alias sf="spf"

# Lazygit
alias lzg="lazygit"

# Lazydocker
alias lzd="lazydocker"

# Shell
alias ls="exa --icons"
alias cat="bat"
alias htop="btop"
#alias find='fd'
#alias grep='rg'
#alias ps='procs'

# Others
alias o="xdg-open"

d() {
  cd ~/Development/"$1"
}
_d() {
  local -a dirs
  dirs=("${(@f)$(ls -d ~/Development/*(/) 2>/dev/null)}")
  dirs=("${dirs[@]##*/}")  # Extract only the folder names
  compadd "$@" -- $dirs
}
compdef _d d

