rc_dir="$HOME/.rc"

if [ -d "$rc_dir" ]; then
  for file in "$rc_dir"/*.zsh; do
    . "$file"
  done
fi
