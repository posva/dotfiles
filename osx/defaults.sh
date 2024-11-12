# Dock
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "55"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0.5"
defaults write com.apple.dock "autohide-delay" -float "0.2"
defaults write com.apple.dock "show-recents" -bool "false"
killall Dock

# Save screenshots to the desktop
defaults write com.apple.screencapture "location" -string "~/Desktop" && killall SystemUIServer

# Safari
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"
killall Safari

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
# column view
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
killall Finder

# Do not offer new disks for backup
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

# Keyboard & Trackpad (Requires restart)
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g com.apple.swipescrolldirection -bool false

# Locale
defaults write -g AppleLocale en_FR

# UI
defaults write -g AppleActionOnDoubleClick Maximize
defaults write -g AppleInterfaceStyle Dark
defaults write -g AppleWindowTabbingMode always
