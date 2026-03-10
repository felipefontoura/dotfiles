# w - atalho para ~/Work/<dir> com autocomplete
function w {
  cd ~/Work/${1:-}
}

function _w_completions {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=($(cd ~/Work && compgen -d -- "$cur"))
}

complete -F _w_completions w

# a - find alias or command docs (a git, a git commit, a → fzf)
function a {
  local aliases_file=~/.aliases

  if [ -z "$1" ]; then
    grep "^alias" "$aliases_file" | sed 's/^alias //' | \
      awk -F= '{name=$1; gsub(/"/, "", name); printf "\033[33m%-12s\033[0m  %s\n", name, $0}' | \
      fzf --ansi --no-preview
    return
  fi

  local result
  result=$(grep "^alias" "$aliases_file")
  for term in "$@"; do
    result=$(echo "$result" | grep -i "$term")
  done

  if [ -n "$result" ]; then
    echo "$result" | awk '{
      line = $0; sub(/^alias /, "", line)
      name = line; sub(/=.*/, "", name); gsub(/"/, "", name)
      val = line; sub(/^[^=]+=/, "", val); gsub(/^"/, "", val)
      comment = ""
      if (index(val, "#") > 0) {
        comment = substr(val, index(val, "#") + 1)
        val = substr(val, 1, index(val, "#") - 1)
        gsub(/^ +| +$/, "", comment)
      }
      gsub(/"? *$/, "", val); gsub(/ +$/, "", val)
      if (comment != "")
        printf "\033[33m%-12s\033[0m  \033[36m%-40s\033[0m  \033[90m%s\033[0m\n", name, val, comment
      else
        printf "\033[33m%-12s\033[0m  \033[36m%s\033[0m\n", name, val
    }'
    return
  fi

  # Nenhum alias encontrado — tentar tldr
  if command -v tldr &>/dev/null; then
    echo -e "\033[90mNenhum alias para '$*' — consultando tldr...\033[0m"
    echo ""
    tldr "$1"
  else
    echo "Nenhum alias encontrado para: $*"
    return 1
  fi
}

# tdl - Tmux Dev Layout
# Layout:
#   ┌────────┬────────┬───────────────┬──────────┐
#   │  AI    │  AI    │    NeoVim    │ Server   │
#   │        │        │               │ Log      │
#   │        │        │               ├──────────┤
#   │        │        │               │ Mini Cmd │
#   ├────────┴────────┴───────────────┴──────────┤
#   │ Terminal                                    │
#   └─────────────────────────────────────────────┘
# Usage: tdl <ai1> [ai2]
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <ai1> [ai2]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local ai1="$1"
  local ai2="${2:-$1}"

  local editor_pane="$TMUX_PANE"

  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Terminal: barra inferior (12%)
  local terminal_pane
  terminal_pane=$(tmux split-window -v -p 12 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # AI: à esquerda do NeoVim (38% para os dois AIs)
  local ai1_pane
  ai1_pane=$(tmux split-window -h -b -p 38 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # AI: à direita do primeiro AI (50% do bloco AI = ~19% cada)
  local ai2_pane
  ai2_pane=$(tmux split-window -h -p 50 -t "$ai1_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Server Log: à direita do editor (12%)
  local log_pane
  log_pane=$(tmux split-window -h -p 12 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Mini Command: embaixo do Server Log (18%)
  local mini_pane
  mini_pane=$(tmux split-window -v -p 18 -t "$log_pane" -c "$current_dir" -P -F '#{pane_id}')

  # Nomeia as panes
  tmux select-pane -t "$editor_pane" -T "editor"
  tmux select-pane -t "$terminal_pane" -T "terminal"
  tmux select-pane -t "$ai1_pane" -T "ai1"
  tmux select-pane -t "$ai2_pane" -T "ai2"
  tmux select-pane -t "$log_pane" -T "log"
  tmux select-pane -t "$mini_pane" -T "cmd"

  # Executa comandos
  tmux send-keys -t "$ai1_pane" "$ai1" C-m
  tmux send-keys -t "$ai2_pane" "$ai2" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m

  # Foco no editor
  tmux select-pane -t "$editor_pane"
}
