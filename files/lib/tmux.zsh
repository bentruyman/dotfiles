(( $+commands[tmux] )) && {
  alias tma="tmux attach -d -t"
  alias tmk="tmux kill-session -t"
  alias tml="tmux list-sessions"

  tmx() {
    if [[ ! -z "$1" ]]; then
      name=$1
    else
      name=$(basename $(pwd) | sed 's/^\.//')
    fi
    echo $name

    tmux attach -t "$name" || tmux new -s "$name"
  }
}
