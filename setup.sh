#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

case "$(uname -s)" in
  Darwin) platform=macos ;;
  Linux) platform=linux ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

# shellcheck source=lib/common.sh
source "${dotfiles_dir}/lib/common.sh"
# shellcheck source=/dev/null
source "${dotfiles_dir}/lib/${platform}.sh"

common_preflight
"${platform}_preflight"
common_repo
common_dotfiles
"${platform}_postdotfiles"
common_packages
"${platform}_postpackages"
common_tooling

report "Setup complete. Open a new shell (or run 'exec fish') to load your environment."
