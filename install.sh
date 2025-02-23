#!/usr/bin/env zsh

##############################################################################
#                                                                            #
# ./install.sh                                                               #
# This script creates symlinks from the home directory to any desired        #
# dotfiles in ~/dotfiles                                                     #
#                                                                            #
##############################################################################
# TODO LIST                                                                  #
# - use git repo for vim                                                     #
# - create a boostrap script                                                 #
# - symlink vim files and other in their proper scripts                      #
#                                                                            #
##############################################################################

show_help() {
  echo "$0 [-h] [-s|--shell] [--no-<something>..] [--only-<something>...]"
  echo "example: $0 --no-vim"
  echo "example: $0 --only-vim"
  echo ""
  echo "-s, --shell:\t equivalent to --only-backup --only-link --only-zsh"
  echo ""
  echo "The availables values for <something> are:"
  grep 'check_option' "$0" | grep 'return' | grep -v 'sed' | sed -e \
  's/.*check_option /\t/g' -e 's/ .*//g' | sort | uniq
}

add_option() {
  local option
  option=$(echo "$1" | sed 's/^--no-//')
  if [[ "$option" != "$1" ]]; then
    export declare "no_$option=YES"
  else
    option=$(echo "$1" | sed 's/^--only-//')
    if [[ "$option" != "$1" ]]; then
      global_no=YES
      export declare "only_$option=YES"
    else
      return 1
    fi
  fi
}

# check_option vim && return inside a function
check_option() {
  local tmp
  if [[ "$global_no" == "YES" ]]; then
    tmp="only_$1"
    [[ "${(P)tmp}" != "YES" ]]
    return "$?"
  else
    tmp="no_$1"
    [[ "${(P)tmp}" == "YES" ]]
    return "$?"
  fi
}

# Start off by parsing the options
while [[ "$#" > 0 ]]; do
  key="$1"

  case $key in
    -h|?|--help)
      show_help
      exit
      ;;
    -s|--shell)
      add_option --only-link
      add_option --only-backup
      add_option --only-zsh
      break
      ;;
    *)
      if add_option "$key"; then
        shift
      else
        echo "Unknown option $key"
        show_help
        exit 1
      fi
      ;;
  esac
done

# Variables

dir=~/dotfiles
olddir=~/dotfiles/__backup
# array of files to symlink in homedir
files=($(find rc-files -maxdepth 1 -type f | tr '\n' ' '))
# add .config to the array
files+=".config"

if ! source ${dir}/task-logger.sh/task-logger.sh 2>/dev/null; then
  echo "ERROR: install git submodules: git submodules init && git submodules update"
  exit 1
fi

# Get OS. Installing in windows is the same as in Linux
# because I use Cygwin
OSX=""
INSTALL="sudo apt-get install -y"
if [[ "$(uname)" = "Darwin" ]]; then
  OSX="YES"
  INSTALL="brew install"
fi

fail() {
  ko
  bad "$@"
}

crash() {
  ko
  bad "$@"
  exit 1
}

####### Verifications and backup #######

# Verification of the install dir
check_install_dir() {
  working -n "Checking dotfiles dir"
  log_cmd -c install-dir test "$(cd "$(dirname "$0")" && pwd)" = "$dir" || crash  "The dotfiles path is wrong! It should be ${dir}"
  cd $dir || crash "Cannot access $dir"
}

# create old_dotfiles in homedir
_backup_dir() {
  mkdir -p $olddir || return 1
  for f in "${files[@]}"; do
    file="$(basename "$f")"
    echo "Checking $file"
    if [ -f ~/."$file" -o -d ~/."$file" ]; then
      echo "Backing up $file"
      mv -f ~/."$file" "$olddir" || return 1
    fi
  done
}
backup_dir() {
  check_option backup && return 0
  local i tmp
  i=0
  tmp="$olddir"
  while [[ -d "$olddir" ]]; do
    ((i++))
    olddir="${tmp}-$i"
  done
  working -n "Backing up files to $olddir"
  log_cmd $0 _backup_dir || crash "Backup failed, aborting"
}

_symlinks() {
  for file in "${files[@]}"; do
    echo "Linking $file"
    ln -fs "${dir}/${file}" ~/."$(basename "$file")" || return 1
  done
}

symlink() {
  check_option link && return 0
  working -n "Symlinking dotfiles"
  log_cmd symlink _symlinks || fail "Symlink failed. Check logs at $LOG_DIR/symlink.err"
}

####### Functions #######

# Install Homebrew only for OSX
# TODO: is this going to allow installing from
install_brew() {
  if [[ "$OSX" ]]; then
    if [[ ! -x $(which brew) ]]; then
      # we need to input the password, so it's better to install like this
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    fi
  fi
}

_clone_prezto() {
  git clone --recursive https://github.com/posva/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || return 1
}

_install_prezto() {
  local rcfile
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
}

install_prezto() {
  if [[ ! -d "${HOME}/.zprezto" ]]; then
    working -n "Cloning prezto"
    log_cmd clone_prezto  _clone_prezto || ko
  fi
  if [[ -d "${HOME}/.zprezto" ]]; then
    working -n "Symlinking prezto files"
    log_cmd install_prezto  _install_prezto || ko
  fi
}

install_nvim() {
  if [[ ! -x $(which nvim) ]]; then
    brew install nvim
  fi
}

install_font() {
  if [[ "$OSX" ]]; then
    cp "$1" ~/Library/Fonts/ || return 1
  else
    mkdir -p ~/.fonts
    cp "$1" ~/.fonts/ || return 1
  fi
  return 0
}

_install_powerfonts() {
  for f in $dir/powerline-fonts/*; do
    install_font "$f" || return 1
  done
}

check_installed_fonts() {
  # return as soon as we find a font that doesn't exist
  for f in $dir/powerline-fonts/*; do
    f=$(basename "$f")
    if [[ "$OSX" ]]; then
      [[ -f "~/Library/Fonts/$f" ]] || return 0
    else
      warning checking $f
      [[ -f "~/.fonts/$f" ]] || return 0
    fi
  done
  return 1
}

install_powerfonts() {
  check_option font && return 0
  if check_installed_fonts; then
    working -n "Copying powerline-fonts"
    log_cmd font-copy _install_powerfonts || fail "Could not copy the fonts. Check logs at $LOG_DIR"
    if [[ -z "$OSX" ]]; then
      working -n "Updating font cache"
      log_cmd font-cache fc-cache -fv || ko
    fi
    info "Remember to change the font to 'Liberation Mono for Powerline'"
  fi
}

install_powerline() {
  check_option powerline && return 0
  if [[ -x $(which pip) ]]; then
    if [[ ! -x $(which powerline) ]]; then
      working -n "Installing powerline-status"
      log_cmd $0 pip install powerline-status || ko
    fi
  else
    warning "powerline-status not installed because pip is missing"
  fi
}

# TODO: redo once I install python
install_python() {
  check_option python && return 0
  local cmd
  if [[ "$OSX" ]]; then
    working -n "Installing Python"
    log_cmd python "$INSTALL" python || ko
  else
    if ! dpkg -s python-dev >/dev/null 2>/dev/null; then
      working -n "Installing Python"
      log_cmd python "$INSTALL" python-dev || ko
    fi
  fi
}

install_pip() {
  check_option python && return 0
  # brew installs pip by default
  if [[ ! "$OSX" ]]; then
    if ! dpkg -s python-pip >/dev/null 2>/dev/null; then
      working -n "Installing pip"
      log_cmd pip $INSTALL python-pip || ko
    fi
  fi
}

install_modern_cmd() {
  brew install catimg git-delta dust bat fd fzf zoxide tree chafa gh ripgrep
}

install_node_volta() {
  if [[ ! -x $(which volta) ]]; then
    curl https://get.volta.sh | bash
  fi
}

# TODO: must be launched in a new session
install_node() {
  if [[ ! -x $(which node) ]]; then
    working -n "Installing node"
    log_cmd node "$INSTALL" volta install node@lts || ko
  fi
}

install_node_globals() {
  volta install @antfu/ni fkill
}

_symlink_karabiner() {
  if [[ "$OSX" ]]; then
    mkdir -p ~/.config
    ln -fs "$dir/karabiner-config" ~/.config/karabiner
  fi
}

symlink_karabiner() {
  working -n "Symlinking karabiner config"
  log_cmd karabiner _symlink_karabiner || ko
}

##### Call everything #####

important "Logs are at $LOG_DIR"

check_install_dir
backup_dir
symlink

install_brew

# breew installations

# No need to install zsh because OSX has it
# install_zsh
# must be done with zsh
# install_prezto


# rustup
# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

install_modern_cmd

install_nvim
brew install ghostty
brew install tmux

# TODO: install lazy vim
# TODO: symlink nvim config
# Symlink move configs to a .config folder and symlink to ~/.config folder

install_node_volta
install_node
# install_node_globals

# Install apps

brew install --cask alfred coconutbaterry discord keycastr iterm2 imageoptim spotify vlc notion rectangle karabiner-elements font-jetbrains-mono-nerd-font gstreamer-runtime lm-studio

symlink_karabiner

# TODO: add when needed
# Use pyenv? instead of everything else
# install_python
# install_pip

# install_powerline

# TODO:
# - copy iterm files
# - copy iterm themes
# - licenes
# - Setapp
# - vscode
# dank mono font

finish
