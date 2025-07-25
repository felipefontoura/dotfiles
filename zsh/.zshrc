# Set path
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Exec fastfetch on terminal
if [ "$(ps -o comm= -p $PPID)" = "alacritty" ] || [ "$(ps -o comm= -p $PPID)" = "kgx" ] || [ "$(ps -o comm= -p $PPID)" = "kitty" ]; then
    fastfetch
fi

echo

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize autocompletion
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
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

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases

# Git
alias g="git"
alias gcl="git clone"
alias gck="git checkout"
alias gcb="git checkout -b"  # Create and checkout a new branch
alias gst="git status"
alias gdf="git diff"
alias gdfs="git diff --staged"  # Show diff of staged changes
alias gad="git add"
alias gada="git add --all"  # Add all changes
alias grm="git rm"   # Remove files
alias gcm="git commit"
alias gcmm="git commit -m"  # Commit with message
alias gcma="git commit --amend"  # Amend previous commit
alias gcman="git commit --amend --no-edit"  # Amend without changing message
alias gpl="git pull"
alias gplr="git pull --rebase"  # Pull with rebase
alias gps="git push"
alias gpsf="git push --force-with-lease"  # Safer force push
alias grb="git rebase"
alias grbi="git rebase -i"  # Interactive rebase
alias grbm="git rebase origin/main"  # Rebase on main
alias grs="git reset"  # Reset
alias grsh="git reset --hard"  # Hard reset
alias gsh="git stash"  # Stash changes
alias gshl="git stash list"  # List stashes
alias gshp="git stash pop"  # Pop stash
alias gsha="git stash apply"  # Apply stash
alias gshd="git stash drop"  # Drop stash
alias gbl="git branch -l"  # List branches
alias gbd="git branch -d"  # Delete branch
alias gbD="git branch -D"  # Force delete branch
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"  # Pretty log
alias gm="git merge"  # Merge
alias gcp="git cherry-pick"  # Cherry-pick
alias gft="git fetch"  # Fetch
alias gfta="git fetch --all"  # Fetch all remotes
alias grmt="git remote -v"  # Show remotes
alias gcf="git config --list"  # List config

# Rails
alias rce="bin/rails credentials:edit"
alias rced="bin/rails credentials:edit -e development"
alias rcep="bin/rails credentials:edit -e production"
alias rcs="bin/rails credentials:show"
alias rcsd="bin/rails credentials:show -e development"
alias rcsp="bin/rails credentials:show -e production"

alias rgmi="bin/rails generate migration"
alias rdmi="bin/rails destroy migration"
alias rgmd="bin/rails generate model"
alias rdmd="bin/rails destroy model"
alias rgct="bin/rails generate controller"
alias rdct="bin/rails destroy controller"
alias rgsc="bin/rails generate scaffold_controller"
alias rdsc="bin/rails destroy scaffold_controller"
alias rghp="bin/rails generate helper"
alias rdhp="bin/rails destroy helper"
alias rgjb="bin/rails generate job"
alias rdjb="bin/rails destroy job"
alias rgat="bin/rails generate authentication"
alias rdat="bin/rails destroy authentication"

alias rc="bin/rails console"
alias rr="bin/rails routes"

alias rt="RUBYOPT='-W:no-deprecated' bin/rails test"
alias rtm="RUBYOPT='-W:no-deprecated' bin/rails test:models"
alias rtc="RUBYOPT='-W:no-deprecated' bin/rails test:controllers"
alias rth="RUBYOPT='-W:no-deprecated' bin/rails test:helpers"
alias rts="RUBYOPT='-W:no-deprecated' bin/rails test:system"
alias rta="RUBYOPT='-W:no-deprecated' bin/rails test:all"

alias rl="bin/rubocop"
alias rlf="bin/rubocop -a"
alias rla="bin/rubocop -A"

alias rbk="bin/brakeman --no-pager"

alias bia="bin/importmap audit"

# Full test suite with status reporting
function rtf() {
  # Color definitions
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local YELLOW='\033[0;33m'
  local BLUE='\033[0;34m'
  local MAGENTA='\033[0;35m'
  local CYAN='\033[0;36m'
  local ORANGE='\033[38;5;208m'
  local PURPLE='\033[38;5;141m'
  local BOLD='\033[1m'
  local NC='\033[0m' # No Color

  echo "${BLUE}󱓟 Running full test suite...${NC}"
  
  echo "${MAGENTA}󱇧 Running Rails tests...${NC}"
  if ! output=$(RUBYOPT='-W:no-deprecated' bin/rails test:all 2>&1); then
    echo "$output"
  fi
  local tests_status=$?

  echo "${PURPLE}󰍉 Running RuboCop...${NC}"
  if ! output=$(bin/rubocop 2>&1); then
    echo "$output"
  fi
  local rubocop_status=$?

  echo "${ORANGE}󰌾 Running Brakeman security checks...${NC}"
  if ! output=$(bin/brakeman --no-pager -q 2>&1); then
    echo "$output"
  fi
  local brakeman_status=$?

  echo "${CYAN}󰏗 Auditing JavaScript dependencies...${NC}"
  if ! output=$(bin/importmap audit 2>&1); then
    echo "$output"
  fi
  local audit_status=$?

  echo "${YELLOW}${BOLD}󰄨 Test Suite Results:${NC}"
  echo "${YELLOW}------------------------${NC}"
  if [ $tests_status -eq 0 ]; then
    echo "${GREEN}󰄬 Rails tests: Passed${NC}"
  else
    echo "${RED} Rails tests: Failed${NC}"
  fi
  
  if [ $rubocop_status -eq 0 ]; then
    echo "${GREEN}󰄬 RuboCop: Passed${NC}"
  else
    echo "${RED} RuboCop: Failed${NC}"
  fi

  if [ $brakeman_status -eq 0 ]; then
    echo "${GREEN}󰄬 Brakeman: Passed${NC}"
  else
    echo "${RED} Brakeman: Failed${NC}"
  fi

  if [ $audit_status -eq 0 ]; then
    echo "${GREEN}󰄬 JS Audit: Passed${NC}"
  else
    echo "${RED} JS Audit: Failed${NC}"
  fi
  echo "${YELLOW}------------------------${NC}"

  if [ $tests_status -eq 0 ] && [ $rubocop_status -eq 0 ] && [ $brakeman_status -eq 0 ] && [ $audit_status -eq 0 ]; then
    echo "${GREEN}${BOLD}󱕦 All checks passed successfully! 󱕦${NC}\n"
    return 0
  else
    echo "${RED}${BOLD} Some checks failed. Please review the output above. ${NC}\n"
    return 1
  fi
}

alias rdbst="bin/rails db:setup"
alias rdbcr="bin/rails db:create"
alias rdbmi="bin/rails db:migrate"
alias rdbrb="bin/rails db:rollback"
alias rdbsd="bin/rails db:seed"
alias rdbsdr="bin/rails db:seed:replant"

alias fsd="bundle exec foreman start -f Procfile.dev"
alias fsp="bundle exec foreman start -f Procfile"

# Bundle
alias ba="bundle add"
alias bi="bundle install"
alias be="bundle exec"

# Kamal
alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${HOME}/.ssh/id_rsa:/root/.ssh/id_rsa" -v /var/run/docker.sock:/var/run/docker.sock -e KAMAL_REGISTRY_PASSWORD=$(env | grep "^KAMAL_" | cut -d '=' -f2) ghcr.io/basecamp/kamal:latest'
alias kd="bin/kamal deploy"
alias kl="bin/kamal logs"
alias klf="bin/kamal logs --follow"
alias klt="bin/kamal logs --tail"
alias kex="bin/kamal exec"
alias kexh="bin/kamal exec --help"
alias kc="bin/kamal console"
alias ks="bin/kamal shell"

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
alias scp="scp -O"

# tmux
alias t="tmux"
alias td="tmux source-file ~/.tmux/dev-layout.tmux"
alias tdr="tmux source-file ~/.tmux/dev-layout-rails.tmux"

# zellij
alias z="zellij"

# Python
alias py="python"
alias ipy="ipython"
alias pyt="pytest"
alias pytv="pytest -v"  # Verbose output
alias pytxvs="pytest -xvs"  # Verbose, stop on first failure, no capture
alias pyts="pytest -s"  # No output capture
alias pytcov="pytest --cov=."  # Run with coverage
alias pytcovr="pytest --cov=. --cov-report=html"  # Generate HTML coverage report

# Virtual Environment
alias venv="python -m venv venv"
alias va="source venv/bin/activate"
alias vd="deactivate"

# Pip
alias pi="pip install"
alias pir="pip install -r requirements.txt"
alias piu="pip install --upgrade"
alias piup="pip install --upgrade pip"
alias pis="pip search"
alias pif="pip freeze"
alias pifl="pip freeze > requirements.txt"
alias pil="pip list"
alias piu="pip uninstall"

# Others
alias o="xdg-open"
alias m="rmpc"

function d() {
  cd ~/Development/"$1"
}
function _d() {
  local -a dirs
  dirs=("${(@f)$(ls -d ~/Development/*(/) 2>/dev/null)}")
  dirs=("${dirs[@]##*/}")  # Extract only the folder names
  compadd "$@" -- $dirs
}
compdef _d d
