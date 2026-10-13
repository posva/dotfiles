# Dock
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "55"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0.5"
defaults write com.apple.dock "autohide-delay" -float "0.2"
defaults write com.apple.dock "show-recents" -bool "false"

# Save screenshots to the desktop
defaults write com.apple.screencapture "location" -string "${HOME}/Desktop"

# Lock Screen
defaults -currentHost write com.apple.screensaver idleTime -int 300 # in seconds
sudo pmset displaysleep 10                                          # in minutes
sudo pmset disksleep 10                                             # in minutes

# Safari
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
# ⌘ + n opens new window instead of new tab
defaults write com.apple.finder AppleWindowTabbingMode -string "manual"
# column view
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"

# Do not offer new disks for backup
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

# Keyboard & Trackpad (Requires restart)
# Disable globe key switching keyboards (0=Nothing, 1=Input Source, 2=Emoji, 3=Dictation)
defaults write com.apple.HIToolbox AppleFnUsageType -int 0
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"
# Allows tabbing through buttons in UI
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"
# Zooms on screen with ctrl + scroll
# FIXME: requires enabling accessibility
# defaults read com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write -g com.apple.swipescrolldirection -bool false
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# Locale
defaults write -g AppleLocale en_FR

# UI
defaults write -g AppleActionOnDoubleClick Maximize
defaults write -g AppleInterfaceStyle Dark
defaults write -g AppleWindowTabbingMode always

# Siri
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool "false"
defaults write com.apple.Siri StatusMenuVisible -bool "false"
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool "false"
defaults write com.apple.SiriNCService AppleLanguages -array "en-US"

# Do not auto insert period with a double space
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Keyoard shortcuts
# Move left a space (⌃⇧⌘←)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{
    enabled = 1;
    value = {
        parameters = (65535, 123, 11927552);
        type = 'standard';
    };
}"

# Move right a space (⌃⇧⌘→)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{
    enabled = 1;
    value = {
        parameters = (65535, 124, 11927552);
        type = 'standard';
    };
}"

# Select previous input source (⌃⌥Space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{
    enabled = 1;
    value = {
        parameters = (32, 49, 786432);
        type = 'standard';
    };
}"

# Select next input source (disabled)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "{
    enabled = 0;
    value = {
        parameters = (32, 49, 786432);
        type = 'standard';
    };
}"

# Input Sources: U.S. + SCIM Pinyin (ITABC)
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
  '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>' \
  '<dict><key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>' \
  '<dict><key>Bundle ID</key><string>com.apple.PressAndHold</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>' \
  '<dict><key>Bundle ID</key><string>com.apple.inputmethod.SCIM</string><key>InputSourceKind</key><string>Keyboard Input Method</string></dict>' \
  '<dict><key>Bundle ID</key><string>com.apple.inputmethod.SCIM</string><key>Input Mode</key><string>com.apple.inputmethod.SCIM.ITABC</string><key>InputSourceKind</key><string>Input Mode</string></dict>'

# Rex
# Shortcuts: ~/.config/rex/init.lua. UI shortcuts take priority over Lua.
# Hidden pane headers require the vertical sidebar on the left.
# Imported Ghostty palettes: Alien Blood (dark), Catppuccin Latte (light).
defaults write com.superlogical.rex Workspace.customThemes -data "$(xxd -p "${HOME}/dotfiles/.config/rex/themes.json" | tr -d '\n')"
defaults write com.superlogical.rex Workspace.balancesSplitsOnCreation -bool false
defaults write com.superlogical.rex Workspace.darkThemeID -string custom-F391B396-8EF3-412E-AB73-55BD5DF12FB1
defaults write com.superlogical.rex Workspace.focusFollowsMouse -bool true
defaults write com.superlogical.rex Workspace.interfaceStyle -string useTheme
defaults write com.superlogical.rex Workspace.lightThemeID -string custom-FC70270A-B7CC-4EE1-84D9-9F69EF52BF26
defaults write com.superlogical.rex Workspace.paneDensity -string compact
defaults write com.superlogical.rex Workspace.prefersGeneratedTitles -bool true
defaults write com.superlogical.rex Workspace.showsPaneHeaders -bool false
defaults write com.superlogical.rex Workspace.sidebarPosition -string left
defaults write com.superlogical.rex Workspace.tabIconCount -int 3
defaults write com.superlogical.rex Workspace.tabIconTintMode -string off
defaults write com.superlogical.rex Workspace.tabStyle -string horizontal
defaults write com.superlogical.rex Workspace.tabsFillAvailableSpace -bool false
defaults write com.superlogical.rex Workspace.terminalAllowsLigatures -bool false
defaults write com.superlogical.rex Workspace.terminalCellHeightPercent -float 0.0
defaults write com.superlogical.rex Workspace.terminalCursorBlinkIntervalMilliseconds -int 500
defaults write com.superlogical.rex Workspace.terminalCursorBlinkUsesCustomInterval -bool false
defaults write com.superlogical.rex Workspace.terminalFontName -string 'JetBrainsMonoNL Nerd Font Mono'
defaults write com.superlogical.rex Workspace.terminalFontPointSize -float 16.0
defaults write com.superlogical.rex Workspace.terminalFontSmoothing -bool true
defaults write com.superlogical.rex Workspace.terminalImproveTextContrast -bool true
defaults write com.superlogical.rex Workspace.terminalUseThemePalette -bool true
defaults write com.superlogical.rex Workspace.terminalUsesDisplayP3 -bool true
defaults write com.superlogical.rex rex.developer-mode-enabled -bool true

# Restart affected apps
killall SystemUIServer
killall Safari
killall Dock
killall Finder
