# dotfiles

## Installation

Clone the repository:

```sh
git clone https://github.com/posva/dotfiles
cd dotfiles
git submodule update --init --recursive
```

- Install dvorak layout
  - clean cache: `sudo rm -f /System/Library/Caches/com.apple.IntlDataCache.le*`
  - restart
  - add dvorak layout keyboard
- Install [hombrew](https://brew.sh)
- Install [Volta](https://volta.sh)
- Run the `install.sh` script
- Install brew clis
- Install brew packages
- Install node with volta and other globals
- Install prezto
- Install Alfred
  - Configure alfred to open with ⌘ + ␣
  - Configure double ⌘ to open clipboard
- Install setapp

## Change computer name

The first two can contain emojis, the last one can't.

- `ComputerName` is the name of the computer in Apple Apps
- `HostName` is the name of the computer in the terminal and ssh (`hostname`).
- `LocalHostName` is the Bonjour name of the computer.

```sh
sudo scutil --set ComputerName "newname"
sudo scutil --set HostName "newname"
sudo scutil --set LocalHostName "newname"
```

## iTerm2 connfiguration

- Import the profiles.json
- Import the Key bindings
- Change theme
-

## Add calendars

Connect to google account.

## Other apps

- [Krisp](https://app.krisp.ai/apps)
  - Disable note taking
  - Make default mic
- Zoom

## OBS

Install with `brew install --cask obs``

- slack
- dropbox

## TODO

- add pip install
- Add powerline clone
- install psutil and powerline-status with pip
- Automate OSX defaults

## GPG

```sh
brewi gpg pinentry-mac
```

Create a key [with these instructions](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)

```sh
touch ~/.gnupg/gpg-agent.conf
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
# test out
echo test | gpg --clearsign
```

Add it [on GitHub](https://github.com/settings/keys).

## Info

- These are my dotfiles, you can install them by launching the `install.sh` script
- You can select what to install with `--only-foo` and `--no-foo`. Launch
  `./install.sh -h` to get a full list of options
- Profit!

## TODO

- Can these be set like this or does it need to be manual?`defaults write -g AppleLanguages '("en-FR", "fr-FR", "zh-Hans-FR", "en-GB", "ja-FR")'`
- Get settings about lock screen and screne saver
