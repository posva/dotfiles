#!/bin/bash

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
    [[ "${!tmp}" != "YES" ]]
    return "$?"
  else
    tmp="no_$1"
    [[ "${!tmp}" == "YES" ]]
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

dir=~/dotfiles               # dotfiles directory
olddir=~/old_dotfiles        # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="bashrc spacemacs spacevim vim gitconfig tmux.conf editorconfig"

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
  for file in $files; do
    if [ -f ~/."$file" -o -d ~/."$file" ]; then
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
  for file in $files; do
    ln -s "${dir}/${file}" ~/."$file" || return 1
  done
}

symlink() {
  check_option link && return 0
  working -n "Symlinking dotfiles"
  log_cmd symlink _symlinks || fail "Symlink failed. Check logs at $LOG_DIR/symlink.err"
}

####### Functions #######

# Install Homebrew only for OSX
install_brew() {
  if [[ "$OSX" ]]; then
    if [[ ! -x $(which brew) ]]; then
      working -n "Installing Homebrew(brew)"
      log_cmd -c brew ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
  fi
}

install_git() {
  if [[ ! -x $(which git) ]]; then
    working -n "Installing Git"
    log_cmd $0 ${INSTALL} git || ko
  fi
}

# Install zsh, need git and brew
_add_zsh() {
  sudo echo $(which zsh) > /etc/shells
}
_install_zsh() {
  if [[ ! -x $(which zsh) ]]; then
    working -n "Installing zsh"
    log_cmd zsh-install ${INSTALL} zsh || return 1
  fi
  if [[ $(basename "$SHELL") != "zsh" ]]; then
    if [[ ! "$(grep "$(which zsh)" /etc/shells)" ]]; then
      working -n "Adding zsh to /etc/shells"
      log_cmd add-zsh _add_zsh || return 1
    fi
    important 'You should manually change your shell with chsh -s $(which zsh)'
    #if [[ $(uname) == 'Linux' || $(uname) == 'Darwin' ]]; then
      #working -n "Changing the default shell for $USER"
      #log_cmd change-shell chsh -s "$(which zsh)" || return 1
    #fi
  fi
  # Install posva zsh theme
  #zsh_theme="oh-my-zsh/themes/posva.zsh-theme"
  #if [ ! -f "$zsh_theme" ]; then
    #working -n "Installing zsh theme"
    #log_cmd zsh-theme ln -s "${dir}/posva.zsh-theme" "$zsh_theme" || return 1
  #fi
  #zsh_theme="oh-my-zsh/themes/posva-powerline.zsh-theme"
  #if [ ! -f "$zsh_theme" ]; then
    #working -n "Installing powerline zsh theme"
    #log_cmd zsh-theme-powerline ln -s "${dir}/posva-powerline.zsh-theme" "$zsh_theme" || return 1
  #fi
}

install_zsh() {
  check_option zsh && return 0
  _install_zsh || ko
}

_clone_prezto() {
  git clone --recursive https://github.com/posva/prezto.git "${HOME}/.zprezto" || return 1
  ln -fs ${HOME}/.zprezto zprezto || return 1
}

_install_prezto() {
  local rcfile
  setopt EXTENDED_GLOB
  for rcfile in "${HOME}"/.zprezto/runcoms/z*; do
    ln -fs "$rcfile" "${ZDOTDIR:-$HOME}/.$(basename "$rcfile")" || return 1
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

_install_vim() {
  local ret elapsed
  if [[ ! -x $(which vim) ]]; then
    if [[ "$OSX" ]]; then
      working -n "Installing vim"
      log_cmd vim-install brew install vim --disable-nls --with-lua --with-ruby --with-python3 || return 1
    else
      if [[ ! -x $(which hg) ]]; then
        working -n "Installing hg(Mercurial)"
        log_cmd hg-install ${INSTALL} mercurial || return 1
      fi
      if [[ ! -d "vim_src" ]]; then
        working -n "Cloning vim repo"
        log_cmd vim-clone hg clone https://vim.googlecode.com/hg/ vim_src || return 1
      fi
      cd vim_src || return 1
      working -n "Installing ncurses"
      log_cmd ncurses-install ${INSTALL} libncurses5-dev || return 1
      working -n "Vim ./configure.sh"
      log_cmd vim-conf ./configure --prefix=/usr/local/ --enable-rubyinterp --enable-pythoninterp --enable-luainterp --with-features=huge || return 1
      working -n "Vim make -j 4"
      log_cmd vim-make make -j 4 || return 1
      working -n "Vim make install"
      log_cmd sudo make install || return 1
    fi
  fi
  # backup dir. My vimrc does this already
  #working -n "Creating vim backup directory"
  #log_cmd vim-back mkdir -p vim/backup || return 1

  # Plugins
  if [[ ! -d ${dir}/vim/bundle/Vundle.vim ]]; then
    working -n "Installing Vundle"
    log_cmd vundle git clone https://github.com/VundleVim/Vundle.vim.git vim/bundle/Vundle.vim || return 1
  fi

  # install plugins
  working -n "Installing vim plugins"
  reset_timer 5
  vim -Nu "$dir/vim-plugins.vim" +PluginInstall! +qall
  ret="$?"
  elapsed="$(get_timer 5)"
  echo -n " [$(ptime $(echo "$elapsed"))]"
  [[ "$ret" = 0 ]] && ok || return 1
}

install_vim() {
  check_option vim && return 0
  _install_vim || ko
}

install_YCM() {
  check_option ycm && return 0
  if [[ -d "${dir}/vim/bundle/YouCompleteMe" ]]; then
    working -n "Compiling YouCompleteMe"
    cd "${dir}/vim/bundle/YouCompleteMe"
    log_cmd ycm ./install.sh --clang-completer || fail "Could not install YouCompleteMe. Check at $LOG_DIR/ycm.err for details"
    cd "$dir"
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
  if [[ ! -d ${dir}/powerline/ ]]; then
    working -n "Cloning powerline"
    log_cmd powerline-git git clone https://github.com/powerline/powerline.git ${dir}/powerline || ko
  fi
  if [[ -x $(which pip) ]]; then
    if [[ ! -x $(which powerline) ]]; then
      working -n "Installing powerline-status"
      log_cmd powerline-status sudo pip install powerline-status || ko
    fi
  else
    warning "powerline-status not installed because pip is missing"
  fi
}

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

install_emojify() {
  working -n "Installing emojify"
  log_cmd emojify gem install terminal-emojify || ko
}

##### Call everything #####

important "Logs are at $LOG_DIR"

check_install_dir
backup_dir
symlink

install_brew

install_git
curl https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight > /usr/local/bin/diff-highlight && chmod +x /usr/local/bin/diff-highlight

install_zsh
install_prezto

install_vim

install_emojify

install_python
install_pip

install_powerline
install_powerfonts

finish
