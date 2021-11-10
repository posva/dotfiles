# dotfiles

## TODO

- add pip install
- Add powerline clone
- install psutil and powerline-status with pip

## Master

- These are my dotfiles, you can install them by launching the `install.sh` script
- You can select what to install with `--only-foo` and `--no-foo`. Launch
  `./install.sh -h` to get a full list of options
- Profit!

## Contact

For further help you can mail me at i@posva.net or open an issue

## Changing key repeat

```sh
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false

defaults write -g AppleLocale en_FR
defaults write -g AppleActionOnDoubleClick Maximize
defaults write -g AppleInterfaceStyle Dark

```
