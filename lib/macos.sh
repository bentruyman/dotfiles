#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2154
#
# macOS-specific phase functions. Sourced by setup.sh on Darwin.
# `dotfiles_dir` is set by the caller (setup.sh).

macos_preflight() {
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  if ! xcode-select -p &>/dev/null; then
    report "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi

  if [ ! "$(/usr/bin/pgrep oahd)" ]; then
    report "Installing Rosetta..."
    softwareupdate --install-rosetta --agree-to-license
  fi
}

macos_postdotfiles() {
  report "Linking launch agents..."
  for agent in "${dotfiles_dir}/launch_agents/"*.plist; do
    local dest_file="${HOME}/Library/LaunchAgents/${agent##*/}"
    mkdir -p "$(dirname "$dest_file")"

    if [[ ! -f "$dest_file" ]]; then
      ln -sf "$agent" "$dest_file"
      launchctl load "$dest_file"
    fi
  done
}

macos_postpackages() {
  if command -v duti &>/dev/null && [[ -d "/Applications/Ghostty.app" ]]; then
    report "Setting Ghostty as the default terminal..."
    duti -s com.mitchellh.ghostty public.unix-executable all
    duti -s com.mitchellh.ghostty public.shell-script all
    duti -s com.mitchellh.ghostty com.apple.terminal.shell-script all
  fi

  local xcode_developer_dir="/Applications/Xcode.app/Contents/Developer"

  if [[ -d "$xcode_developer_dir" ]]; then
    local current_developer_dir
    current_developer_dir=$(xcode-select -p 2>/dev/null || true)

    if [[ "$current_developer_dir" != "$xcode_developer_dir" ]]; then
      report "Switching active developer directory to Xcode..."
      sudo xcode-select --switch "$xcode_developer_dir"
    fi

    if xcodebuild -version &>/dev/null; then
      if ! xcodebuild -checkFirstLaunchStatus &>/dev/null; then
        report "Completing Xcode first-launch setup..."

        set +e
        sudo xcodebuild -runFirstLaunch
        local xcode_setup_status=$?
        set -e

        if [[ $xcode_setup_status -ne 0 ]]; then
          report "Skipping Xcode first-launch setup because it is not ready yet."
          echo "Open Xcode once to finish installation, then rerun setup.sh."
        fi
      fi
    else
      report "Skipping Xcode license acceptance because Xcode is not ready yet."
    fi
  fi

  macos_gpg
  macos_defaults
  macos_mackup
}

macos_gpg() {
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

      local gpg_key=""
      local line
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

        local gpg_key_id
        gpg_key_id=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
        if [[ -n "$gpg_key_id" ]]; then
          echo -e "trust\n5\ny\n" | gpg --command-fd 0 --edit-key "$gpg_key_id" >/dev/null 2>&1 || true
        fi
      fi
    fi
  fi
}

macos_defaults() {
  # Use dark mode
  defaults write -g AppleInterfaceStyle -string Dark

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

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"
  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true

  # Hide all Desktop icons
  defaults write com.apple.finder CreateDesktop false

  # Open new windows in the ${HOME} directory
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
  defaults write com.apple.finder NewWindowTarget -string "PfHm"

  # Open new windows using list view
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

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

  local dock_apps=(
    "/Applications/Slack.app"
    "/System/Applications/Music.app"
    "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Calendar.app"
    "/Applications/Pixelmator Pro.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Ghostty.app"
    "/System/Applications/System Settings.app"
  )

  for app in "${dock_apps[@]}"; do
    if [[ -d "$app" ]]; then
      defaults write com.apple.dock persistent-apps -array-add \
        "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
  done
}

macos_mackup() {
  if ! command -v mackup &>/dev/null; then
    return
  fi

  local mackup_diffs
  mackup_diffs=$(mackup restore -n | awk '{print " - " substr($0, 11, length()-13)}')

  if [[ -n "$mackup_diffs" ]]; then
    echo "The following application settings differ from the backup:"
    echo "$mackup_diffs"
    echo
    echo "Run 'mackup restore' or 'mackup backup' to commit these changes."
  fi
}
