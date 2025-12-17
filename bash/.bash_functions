# w - atalho para ~/Work/<dir> com autocomplete
function w {
  cd ~/Work/${1:-}
}

function _w_completions {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=($(cd ~/Work && compgen -d -- "$cur"))
}

complete -F _w_completions w
