#!/usr/bin/env bash
set -e

[[ "$OSTYPE" =~ ^darwin ]] || return 0

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sudo -v

# Prevent from asking for sudo password again until process ends
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Homebrew                                                                    *
###############################################################################

if ! hash brew &> /dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

brew update
brew upgrade

brew bundle install --file="$SCRIPT_DIR/brew/agnostic/Brewfile"
brew bundle install --file="$SCRIPT_DIR/brew/macos/Brewfile"

brew cleanup

###############################################################################
# General                                                                     #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

###############################################################################
# UI                                                                          #
###############################################################################

# Use dark menu bar and Dock
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark;

###############################################################################
# Input                                                                       #
###############################################################################

# Disable press-and-hold and just repeat key presses
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Remove text shortcuts
defaults write NSGlobalDomain NSUserDictionaryReplacementItems -array

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Enable Tab focus for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

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

# Don't offer storing passwords
defaults write com.apple.Safari AutoFillPasswords -int 0

###############################################################################
# Shell                                                                       #
###############################################################################

ZSH_BIN=$(command -v zsh 2> /dev/null)

# Add ZSH to list of valid shells
if [[ -x "$ZSH_BIN" ]] && ! grep -q "$ZSH_BIN" /etc/shells; then
  echo "$ZSH_BIN" | sudo tee -a /etc/shells &> /dev/null
fi

# Change shell to ZSH
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi

$ZSH_BIN -i "${SCRIPT_DIR}/postsetup.zsh"

###############################################################################
# Visual Studio Code
###############################################################################

# TODO: this should work cross-platform
VSCODE_EXTS=(
  AlanWalk.markdown-toc
  EditorConfig.EditorConfig
  Stephanvs.dot
  bierner.emojisense
  bierner.markdown-emoji
  bierner.markdown-preview-github-styles
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  CoenraadS.bracket-pair-colorizer
  dbaeumer.vscode-eslint
  dustinsanders.an-old-hope-theme-vscode
  eamodio.gitlens
  EFanZh.graphviz-preview
  eg2.vscode-npm-script
  Equinusocio.vsc-material-theme
  fallenwood.vimL
  felipecaputo.git-project-manager
  formulahendry.auto-rename-tag
  Gruntfuggly.todo-tree
  joelday.docthis
  minhthai.vscode-todo-parser
  ms-vscode.Go
  octref.vetur
  Orta.vscode-jest
  PeterJausovec.vscode-docker
  PKief.material-icon-theme
  pmneo.tsimporter
  quicktype.quicktype
  rebornix.ruby
  robinbentley.sass-indented
  shinnn.stylelint
  streetsidesoftware.code-spell-checker
  timonwong.shellcheck
  vscodevim.vim
  WallabyJs.quokka-vscode
  wayou.vscode-todo-highlight
  xabikos.JavaScriptSnippets
  yzhang.markdown-all-in-one
  zamerick.vscode-caddyfile-syntax
  zhuangtongfa.Material-theme
)

for ext in "${VSCODE_EXTS[@]}"; do
  code --install-extension "$ext"
done

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "cfprefsd" "Dashboard" "Dock" "Finder" "Safari" "SystemUIServer"; do
  set +e
  killall "$app" > /dev/null 2>&1
  set -e
done
echo
echo "Done. Note that some of these changes require a logout/restart to take effect."
echo

###############################################################################
# Restore application settings
###############################################################################

# mackup restore
echo "If necessary, restore application settings:"
echo "$ mackup restore"
