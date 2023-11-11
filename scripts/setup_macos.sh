set -e

[[ "$OSTYPE" =~ ^darwin ]] || return 0

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

###############################################################################
# System
###############################################################################

# Installl Rosetta
if [ ! "$(/usr/bin/pgrep oahd)" ]; then
  softwareupdate --install-rosetta --agree-to-license
fi

###############################################################################
# Environment
###############################################################################

for agent in "$SCRIPT_DIR/launch_agents/"*.plist; do
  dest_file="$HOME/Library/LaunchAgents/${agent##*/}"

  if [[ ! -f "$dest_file" ]]; then
    ln -sf "$agent" "$dest_file"
    launchctl load "$dest_file"
  fi
done

###############################################################################
# Homebrew                                                                    *
###############################################################################

if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d /opt/homebrew ]]; then
    export PATH=/opt/homebrew/bin:$PATH
  fi
fi

brew update
brew upgrade

brew bundle install --file="$SCRIPT_DIR/brew/agnostic/Brewfile"
brew bundle install --file="$SCRIPT_DIR/brew/macos/Brewfile"

brew cleanup

###############################################################################
# Xcode
###############################################################################

sudo xcodebuild -license accept

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
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Hide all Desktop icons
defaults write com.apple.finder CreateDesktop false

# Open new windows in the $HOME directory
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Open new windows using list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Automatically hide the Dock
defaults write com.apple.dock autohide -bool true

# Disable Hot Corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari                                                                      #
###############################################################################

# Show debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Show Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "cfprefsd" "Dashboard" "Dock" "Finder" "Safari" "SystemUIServer"; do
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
