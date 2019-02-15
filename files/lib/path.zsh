__() {
  local -a current_path desired
  local p
  desired=(
    $GOPATH/bin
    /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/sbin /usr/local/bin
    /usr/sbin /usr/bin
    /sbin /bin
  )

  # macOS uses path_helper to add other paths from other apps
  if [[ -x /usr/libexec/path_helper ]]; then
    path=()
    eval "$(/usr/libexec/path_helper -s)"
  fi

  current_path=($path)
  path=()

  for p in $current_path; do
    p=${p:A}
    [[ ${desired[(r)$p]} ]] || {
      _::path::suffix $p
    }
  done

  for p in $desired; do
    p=${p:A}
    _::path::suffix $p
  done
} && __

unset -f __
