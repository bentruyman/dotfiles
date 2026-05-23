#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2154
#
# Shared phase functions used by setup.sh on every supported platform.
# Sourced by setup.sh; not meant to be executed directly.
# `dotfiles_dir` is set by the caller (setup.sh).

report() { echo -e "\033[1;34m$*\033[0m"; }
report_error() {
  local exit_code=$?
  local line_number=$1
  local failed_command=$2
  local source_file=${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}

  if [[ ${#BASH_LINENO[@]} -gt 0 && -n "${BASH_LINENO[0]}" ]]; then
    line_number=${BASH_LINENO[0]}
  fi

  echo
  echo "setup.sh failed at ${source_file}:${line_number}: ${failed_command}"
  exit "$exit_code"
}

common_preflight() {
  trap 'report_error "${LINENO}" "${BASH_COMMAND}"' ERR
}

common_dotfiles() {
  report "Linking dotfiles..."
  for file in bin config gitconfig gitignore_global mackup.cfg tmux.conf; do
    if [ -d "${HOME}/.$file" ]; then
      echo "${HOME}/.$file is a directory. Skipping..."
    else
      ln -sf "${dotfiles_dir}/files/${file}" "${HOME}/.$file"
    fi
  done

  report "Installing repositories..."
  clone_repo() {
    [ -d "$2" ] || git clone --depth 1 --recursive "$1" "$2"
  }
  clone_repo https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  clone_repo https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"

  report "Creating machine-specific dotfiles directories..."
  mkdir -p "${HOME}/.dotfiles/fish"
  mkdir -p "${HOME}/.dotfiles/nvim"
}

common_packages() {
  if ! command -v brew &>/dev/null; then
    report "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Put brew on PATH after install (or in a fresh shell on subsequent runs).
  # Must happen before `brew update` so this shell can find the binary.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if ! command -v brew &>/dev/null; then
    echo "Homebrew installation failed: 'brew' is not on PATH" >&2
    exit 1
  fi

  report "Installing Homebrew packages..."
  brew update
  brew upgrade
  brew bundle install --file="${dotfiles_dir}/Brewfile"
  brew cleanup
}

common_tooling() {
  if [[ ! -f "${HOME}/.config/fish/functions/fish_user_key_bindings.fish" ]] || ! grep -q "fzf --fish" "${HOME}/.config/fish/functions/fish_user_key_bindings.fish"; then
    report "Installing FZF..."
    "${HOME}/.fzf/install" --key-bindings --completion --no-{update-rc,bash,zsh}
  fi

  report "Configuring Git..."
  configure_git_user() {
    local current_value
    current_value=$(git config user."$1" 2>/dev/null || true)

    if [[ -z "$current_value" ]]; then
      read -rp "Enter your git user $1: " config_value
      git config -f ~/.gitconfig_user user."$1" "$config_value"
    fi
  }
  configure_git_user "email"
  configure_git_user "name"

  export PATH="${HOME}/.proto/shims:${HOME}/.proto/bin:${PATH}"

  if [ ! -d "${HOME}/.proto" ]; then
    report "Installing Proto..."
    bash <(curl -fsSL https://moonrepo.dev/install/proto.sh) --no-profile --yes
  fi

  ln -sf "${dotfiles_dir}/files/proto/prototools" "${HOME}/.proto/.prototools"

  proto install --config-mode all

  common_shell
  common_ssh
}

common_shell() {
  local fish_bin
  fish_bin=$(command -v fish 2>/dev/null || true)

  if [[ -z "$fish_bin" || ! -x "$fish_bin" ]]; then
    echo "fish is not installed; skipping shell configuration." >&2
    return
  fi

  if ! grep -qxF "$fish_bin" /etc/shells; then
    report "Adding Fish to list of valid shells..."
    echo "$fish_bin" | sudo tee -a /etc/shells &>/dev/null
  fi

  if [[ "$SHELL" != "$fish_bin" ]]; then
    report "Changing shell to Fish..."
    if chsh -s "$fish_bin" 2>/tmp/chsh.err \
      || sudo chsh -s "$fish_bin" "$USER" 2>/tmp/chsh.err; then
      echo "You may need to log into your shell again to take advantage of updates:"
      echo "$fish_bin"
    else
      echo "Could not change login shell automatically:"
      sed 's/^/  /' /tmp/chsh.err
      echo "Set Fish via your identity provider, or add 'exec $fish_bin -l' to ~/.bashrc."
    fi
    rm -f /tmp/chsh.err
  fi

  if [[ ! -f "${HOME}/.config/fish/functions/fisher.fish" ]]; then
    report "Installing Fisher..."
    "$fish_bin" -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  fi

  local fisher_plugins=(
    catppuccin/fish
    ilancosman/tide@v6
    jethrokuan/z
  )

  local desired_plugins
  local installed_plugins
  local plugins_to_install
  desired_plugins=$(printf "%s\n" "${fisher_plugins[@]}" | sort -u)
  installed_plugins=$("$fish_bin" -c 'fisher list | sort')
  plugins_to_install=$(comm -23 <(echo "$desired_plugins") <(echo "$installed_plugins"))

  if [[ -n "$plugins_to_install" ]]; then
    while IFS= read -r plugin; do
      "$fish_bin" -c "fisher install $plugin"
    done <<<"$plugins_to_install"
  fi

  "$fish_bin" -c "fisher update"

  # Nerd Font glyphs are only installed via cask on macOS, so use a leaner
  # icon set on Linux to avoid tofu in the prompt.
  local tide_icons='Many icons'
  if [[ "$(uname -s)" != "Darwin" ]]; then
    tide_icons='Few icons'
  fi

  TERM="${TERM:-xterm-256color}" "$fish_bin" -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='${tide_icons}' --transient=No"
}

common_ssh() {
  if [[ -f "${HOME}/.ssh/id_rsa" ]]; then
    return
  fi

  report "Generating SSH keys..."
  ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/id_rsa" -N ""

  echo
  if command -v pbcopy &>/dev/null; then
    pbcopy <"${HOME}/.ssh/id_rsa.pub"
    echo "Your SSH public key has been copied to the clipboard."
  else
    echo "Your SSH public key:"
    echo
    cat "${HOME}/.ssh/id_rsa.pub"
    echo
  fi

  if command -v open &>/dev/null; then
    echo "Opening GitHub to add the key - please paste it there."
    echo
    open "https://github.com/settings/ssh/new"
  else
    echo "Add it at https://github.com/settings/ssh/new"
    echo
  fi
}
