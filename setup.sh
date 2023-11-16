#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

report() { echo -e "\033[1;34m$*\033[0m"; }

###############################################################################
# Dotfiles
###############################################################################

report "Linking dotfiles..."
for file in config gitconfig gitignore_global mackup.cfg tmux.conf; do
  if [ -d "${HOME}/.$file" ]; then
    echo "${HOME}/.$file is a directory. Skipping..."
  else
    ln -sf "${dotfiles_dir}/${file}" "${HOME}/.$file"
  fi
done

report "Installing repositories..."
clone_repo() {
  [ -d "$2" ] || git clone --depth 1 --recursive "$1" "$2"
}
clone_repo https://github.com/LazyVim/starter "${HOME}/.config/nvim"
clone_repo https://github.com/junegunn/fzf.git "${HOME}/.fzf"
clone_repo https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"

###############################################################################
# System
###############################################################################

if ! xcode-select -p &>/dev/null; then
  report "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
  sudo xcodebuild -license accept
fi

if [ ! "$(/usr/bin/pgrep oahd)" ]; then
  report "Installing Rosetta..."
  softwareupdate --install-rosetta --agree-to-license
fi

if ! grep -q "pam_tid.so" /etc/pam.d/sudo; then
  report "Enabling TouchID for sudo calls..."
  sudo sed -i '' '2i\
auth       optional       /opt/homebrew/lib/pam/pam_reattach.so\
auth       sufficient     pam_tid.so\
' /etc/pam.d/sudo
fi

if [ -d ~/Library/Mail ] && [ ! -r ~/Library/Mail ]; then
  echo "Full Disk Access is not enabled for this Terminal."
  echo "Please enable it in System Preferences > Security & Privacy > Privacy > Full Disk Access."
  open "x-apple.systempreferences:com.apple.preference.security"
  read -rp "Press any key to continue..."
fi

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

###############################################################################
# FZF
###############################################################################

if ! grep -q "fzf_key_bindings" "${HOME}/.config/fish/functions/fish_user_key_bindings.fish"; then
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
  killall gpg-agent
fi

# Check if any GPG keys exist already
if ! gpg --list-keys >/dev/null 2>&1; then
  # Ask user to paste a private key in
  echo "No GPG keys found. Please paste your private key:"
  read -r -d '' | gpg --import
fi

###############################################################################
# Node.js
###############################################################################

if [ ! -d "${HOME}/.volta/bin" ]; then
  report "Installing Volta..."
  curl https://get.volta.sh | bash -s -- --skip-setup
fi

export PATH="${HOME}/.volta/bin:${PATH}"

if ! node -v &>/dev/null; then
  report "Installing Node.js..."
  volta install node
fi

###############################################################################
# Python
###############################################################################

report "Installing pip packages..."
pip3 install --upgrade neovim-remote

###############################################################################
# Rust
###############################################################################

if [[ ! -f "${HOME}/.cargo/env" ]]; then
  report "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

###############################################################################
# UI                                                                          #
###############################################################################

# Use dark menu bar and Dock
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
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others
defaults delete com.apple.dock recent-apps

DOCK_APPS=(
  "/Applications/Discord.app"
  "/Applications/Slack.app"
  "/System/Applications/Music.app"
  "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
  "/System/Applications/Mail.app"
  "/System/Applications/Calendar.app"
  "/Applications/Visual Studio Code.app"
  "/Applications/kitty.app"
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
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Show Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true

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

# Add FISH to list of valid shells
if [[ -x "$FISH_BIN" ]] && ! grep -q "$FISH_BIN" /etc/shells; then
  report "Adding Fish to list of valid shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells &>/dev/null
fi

# Change shell to Fish
if [[ "$SHELL" != "$FISH_BIN" ]]; then
  report "Changing shell to Fish..."
  sudo chsh -s "$FISH_BIN" "$USER"

  echo "You may need to log into your shell again to take advantage of
  updates:"
  echo "$FISH_BIN"
fi

###############################################################################
# SSH
###############################################################################

# Generate SSH keys
if [[ ! -f "${HOME}/.ssh/id_rsa" ]]; then
  report "Generating SSH keys..."
  ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/id_rsa" -N ""

  # Copy the puplic key to clipboard
  pbcopy <"${HOME}/.ssh/id_rsa.pub"

  # Open up GitHub.com
  open "https://github.com/settings/ssh/new"
fi
