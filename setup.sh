#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

report() { echo -e "\033[1;34m$*\033[0m"; }
report_error() {
  local exit_code=$?
  local line_number=$1
  local failed_command=$2

  echo
  echo "setup.sh failed at line ${line_number}: ${failed_command}"
  exit "$exit_code"
}
trap 'report_error "${LINENO}" "${BASH_COMMAND}"' ERR

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

###############################################################################
# Initial
###############################################################################

if ! xcode-select -p &>/dev/null; then
  report "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

if [ ! "$(/usr/bin/pgrep oahd)" ]; then
  report "Installing Rosetta..."
  softwareupdate --install-rosetta --agree-to-license
fi

###############################################################################
# Dotfiles
###############################################################################

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

###############################################################################
# Environment
###############################################################################

report "Linking launch agents..."
for agent in "${dotfiles_dir}/launch_agents/"*.plist; do
  dest_file="${HOME}/Library/LaunchAgents/${agent##*/}"
  mkdir -p "$(dirname "$dest_file")"

  if [[ ! -f "$dest_file" ]]; then
    ln -sf "$agent" "$dest_file"
    launchctl load "$dest_file"
  fi
done

###############################################################################
# Homebrew                                                                    *
###############################################################################

if ! command -v brew &>/dev/null; then
  report "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d /opt/homebrew ]]; then
    export PATH=/opt/homebrew/bin:$PATH
  fi
fi

report "Installing Homebrew packages..."
brew update
brew upgrade
brew bundle install --file="${dotfiles_dir}/Brewfile"
brew cleanup

XCODE_DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

if [[ -d "$XCODE_DEVELOPER_DIR" ]]; then
  current_developer_dir=$(xcode-select -p 2>/dev/null || true)

  if [[ "$current_developer_dir" != "$XCODE_DEVELOPER_DIR" ]]; then
    report "Switching active developer directory to Xcode..."
    sudo xcode-select --switch "$XCODE_DEVELOPER_DIR"
  fi

  if xcodebuild -version &>/dev/null; then
    report "Accepting Xcode license..."
    sudo xcodebuild -license accept
  else
    report "Skipping Xcode license acceptance because Xcode is not ready yet."
  fi
fi

###############################################################################
# FZF
###############################################################################

if [[ ! -f "${HOME}/.config/fish/functions/fish_user_key_bindings.fish" ]] || ! grep -q "fzf --fish" "${HOME}/.config/fish/functions/fish_user_key_bindings.fish"; then
  report "Installing FZF..."
  "${HOME}/.fzf/install" --key-bindings --completion --no-{update-rc,bash,zsh}
fi

###############################################################################
# Git
###############################################################################

configure_git_user() {
  if [[ -z $(git config user."$1") ]]; then
    read -rp "Enter your git user $1: " config_value
    git config -f ~/.gitconfig_user user."$1" "$config_value"
  fi
}
configure_git_user "email"
configure_git_user "name"

###############################################################################
# GPG
###############################################################################

if [[ ! -d "${HOME}/.gnupg" ]]; then
  report "Setting up Pinentry..."
  mkdir "${HOME}/.gnupg"
  echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >"${HOME}/.gnupg/gpg-agent.conf"
  echo 'use-agent' >"${HOME}/.gnupg/gpg.conf"
  chmod 700 "${HOME}/.gnupg"
  killall gpg-agent || true
fi

if ! gpg --list-secret-keys 2>/dev/null | grep -q .; then
  echo
  echo "No GPG private key found. Would you like to import one? (y/n)"
  read -r import_gpg

  if [[ "$import_gpg" == "y" ]]; then
    echo "Please paste your GPG private key (including BEGIN/END lines)."
    echo "The key will be read automatically until the END line is detected."
    echo

    gpg_key=""
    while IFS= read -r line; do
      gpg_key="${gpg_key}${line}"$'\n'
      if [[ "$line" == *"-----END PGP PRIVATE KEY BLOCK-----"* ]]; then
        break
      fi
    done

    if [[ -n "$gpg_key" ]]; then
      if echo "$gpg_key" | gpg --import 2>/dev/null; then
        report "GPG key imported successfully"
      else
        echo "Failed to import GPG key"
      fi

      # Trust the key if one is now present
      gpg_key_id=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
      if [[ -n "$gpg_key_id" ]]; then
        echo -e "trust\n5\ny\n" | gpg --command-fd 0 --edit-key "$gpg_key_id" >/dev/null 2>&1 || true
      fi
    fi
  fi
fi

###############################################################################
# Proto
###############################################################################

if [ ! -d "${HOME}/.proto" ]; then
  report "Installing Proto..."
  bash <(curl -fsSL https://moonrepo.dev/install/proto.sh) --no-profile --yes

  export PATH="${HOME}/.proto/shims:${HOME}/.proto/bin:${PATH}"
fi

ln -sf "${dotfiles_dir}/files/proto/prototools" "${HOME}/.proto/.prototools"

proto install --config-mode all

###############################################################################
# UI                                                                          #
###############################################################################

# Use dark mode
defaults write -g AppleInterfaceStyle -string Dark

###############################################################################
# Input                                                                       #
###############################################################################

# Disable press-and-hold and just repeat key presses
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a fast key repeat
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Remove text shortcuts
defaults write -g NSUserDictionaryReplacementItems -array

# Disable automatic period substitution
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable automatic spelling correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Enable Tab focus for all controls
defaults write -g AppleKeyboardUIMode -int 2

# Disable the dictation prompt
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMPromptedForEnhancedDictation -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Hide all Desktop icons
defaults write com.apple.finder CreateDesktop false

# Open new windows in the ${HOME} directory
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Open new windows using list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Automatically hide the Dock
defaults write com.apple.dock autohide -bool true

# Resize Dock icons
defaults write com.apple.dock tilesize -int 48

# Disable Hot Corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

# Set Dock items
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock recent-apps -array

# Hide Dock items
defaults write com.apple.dock show-recents -bool false

DOCK_APPS=(
  "/Applications/Discord.app"
  "/Applications/Slack.app"
  "/System/Applications/Music.app"
  "/Applications/Spotify.app"
  "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
  "/System/Applications/Mail.app"
  "/System/Applications/Calendar.app"
  "$HOME/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app"
  "/Applications/Pixelmator Pro.app"
  "/Applications/Visual Studio Code.app"
  "/Applications/Ghostty.app"
  "/System/Applications/System Settings.app"
)

for app in "${DOCK_APPS[@]}"; do
  if [[ -d "$app" ]]; then
    defaults write com.apple.dock persistent-apps -array-add \
      "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  fi
done

###############################################################################
# Safari                                                                      #
###############################################################################

# Show Debug menu
if [[ -d "${HOME}/Library/Containers/com.apple.Safari" ]]; then
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Show Develop menu
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
else
  report "Skipping Safari defaults (open Safari once, then rerun setup.sh to apply)."
fi

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "cfprefsd" "Dashboard" "Dock" "Finder" "SystemUIServer"; do
  set +e
  killall "$app" >/dev/null 2>&1
  set -e
done
echo
echo "Done. Note that some of these changes require a logout/restart to take effect."
echo

###############################################################################
# Restore application settings
###############################################################################

mackup_diffs=$(mackup restore -n | awk '{print " - " substr($0, 11, length()-13)}')

if [[ -n "$mackup_diffs" ]]; then
  echo "The following application settings differ from the backup:"
  echo "$mackup_diffs"
  echo
  echo "Run 'mackup restore' or 'mackup backup' to commit these changes."
fi

###############################################################################
# Shell
###############################################################################

FISH_BIN=$(command -v fish 2>/dev/null)

if [[ -x "$FISH_BIN" ]] && ! grep -q "$FISH_BIN" /etc/shells; then
  report "Adding Fish to list of valid shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells &>/dev/null
fi

if [[ "$SHELL" != "$FISH_BIN" ]]; then
  report "Changing shell to Fish..."
  sudo chsh -s "$FISH_BIN" "$USER"

  echo "You may need to log into your shell again to take advantage of updates:"
  echo "$FISH_BIN"
fi

if [[ ! -f "${HOME}/.config/fish/functions/fisher.fish" ]]; then
  report "Installing Fisher..."
  $FISH_BIN -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi

FISHER_PLUGINS=(
  catppuccin/fish
  ilancosman/tide@v6
  jethrokuan/z
)

DESIRED_PLUGINS=$(printf "%s\n" "${FISHER_PLUGINS[@]}" | sort -u)
INSTALLED_PLUGINS=$($FISH_BIN -c 'fisher list | sort')
PLUGINS_TO_INSTALL=$(comm -23 <(echo "$DESIRED_PLUGINS") <(echo "$INSTALLED_PLUGINS"))

if [[ ! -z "$PLUGINS_TO_INSTALL" ]]; then
  while IFS= read -r plugin; do
    $FISH_BIN -c "fisher install $plugin"
  done <<<"$PLUGINS_TO_INSTALL"
fi

$FISH_BIN -c "fisher update"

$FISH_BIN -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Many icons' --transient=No"

###############################################################################
# SSH
###############################################################################

if [[ ! -f "${HOME}/.ssh/id_rsa" ]]; then
  report "Generating SSH keys..."
  ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/id_rsa" -N ""

  pbcopy <"${HOME}/.ssh/id_rsa.pub"

  echo
  echo "Your SSH public key has been copied to the clipboard."
  echo "Opening GitHub to add the key - please paste it there."
  echo
  open "https://github.com/settings/ssh/new"
fi
