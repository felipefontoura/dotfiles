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
