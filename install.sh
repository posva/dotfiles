#!/bin/bash
############################
# ./install.sh
# This script creates symlinks from the home directory to any desired dotfiles
# in ~/dotfiles
# Install brew (OSX only), git, zsh (can be skipped with -z), oh-my-zsh, vim
############################

########## Variables

dir=~/dotfiles               # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc gitconfig oh-my-zsh tmux.conf"    # list of files/folders to symlink in homedir

# Get OS. Installing in windows is the same as in Linux
# because I use Cygwin
OSX=""
INSTALL="sudo apt-get install -y"
if [[ "`uname`" = "Darwin" ]]; then
  OSX="YES"
  INSTALL="brew install"
fi

# Colors makes it easier to read
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
BLUE="\e[94m"
RESET="\e[m"

function good_msg {
  echo -e "${GREEN}${1}${RESET}"
}

function bad_msg {
  echo -e "${RED}${1}${RESET}"
}

function info_msg {
  if [[ "$1" = "-n" ]]; then
    echo -ne "${BLUE}${2}${RESET}"
  else
    echo -e "${BLUE}${1}${RESET}"
  fi
}

function warning_msg {
  if [[ "$1" = "-n" ]]; then
    echo -ne "${YELLOW}${2}${RESET}"
  else
    echo -e "${YELLOW}${1}${RESET}"
  fi
}

####### Verifications and backup #######

# Verification of the install dir
if [[ ! "$(cd `dirname $0` && pwd)" == "$dir" ]]; then
  bad_msg "The dotfiles repo is at a wrong place. It should be at ${dir}"
  exit 1
fi

# create dotfiles_old in homedir
info_msg -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
rm -rf $olddir && mkdir -p $olddir && good_msg "done" || bad_msg "error"

# change to the dotfiles directory
info_msg -n "Changing to the $dir directory ..."
if cd $dir; then
  good_msg "done"
else
  bad_msg "error"
  exit 1
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
  info_msg -n "Moving $file to $olddir..."
  if [ -f ~/.$file -o -d ~/.$file ]; then
    mv -f ~/.$file $olddir && good_msg "done" || bad_msg "error"
  fi
  info_msg -n "Creating symlink to $file in home directory..."
  ln -s $dir/$file ~/.$file && good_msg "done" || bad_msg "error"
done


####### Functions #######

# Install Homebrew only for OSX
function install_brew {
  if [[ "$OSX" ]]; then
    if [[ ! -x `which brew` ]]; then
      info_msg -n "Installing Homebrew(brew)..."
      if ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" ; then
        good_msg "done"
      else
        bad_msg "error"
        exit 1
      fi
    fi
  fi
}

function install_git {
  if [[ ! -x `which git` ]]; then
    info_msg -n "Installing Git..."
    if ${INSTALL} git; then
      good_msg "done"
    else
      bad_msg "error"
      exit 1
    fi
  fi
}

# Install zsh, need git and brew
function install_zsh {
# Test to see if zshell is installed.  If it is:
if [[ -x `which zsh` ]]; then
  # Clone my oh-my-zsh repository from GitHub only if it isn't already present
  if [[ ! -d $dir/oh-my-zsh/ ]]; then
    info_msg "Cloning oh-my-zsh"
    if ! git clone https://github.com/robbyrussell/oh-my-zsh.git; then
      bad_msg "error"
      exit 1
    fi
  fi
  # Set the default shell to zsh if it isn't currently set to zsh
  if [[ ! `echo $SHELL` == `which zsh` ]]; then
    if [[ ! "$(grep `which zsh` /etc/shells)" ]]; then
      if [[ `uname` == 'Linux' || `uname` == 'Darwin' ]]; then
        sudo echo "`which zsh`" >> /etc/shells
      fi
    fi
    # sed -i "s/$USER\:\/bin\/bash/$USER\:\/bin\/zsh/g" /etc/passwd
      warning_msg "Manually change it with chsh -s `which zsh`"
  fi

  # Install posva zsh theme
  zsh_theme="oh-my-zsh/themes/posva.zsh-theme"
  if [ ! -f $zsh_theme ]; then
    info_msg -n "Installing zsh theme..."
    wget -q https://raw.github.com/posva/oh-my-zsh/6e611f2f45320eef572d13fc3c57391fd0beedb3/themes/posva.zsh-theme -O $zsh_theme && good_msg "done" || bad_msg "error"
  fi
else
    info_msg "Installig zsh"
    ${INSTALL} zsh || exit 1
    # install oh-my-zsh if installation was successful
    install_zsh
fi
}

# Install some programs I cannot live without
function install_more {
  if [[ ! -x `which source-highlight` ]]; then
    info_msg "Installing source-highlight"
    ${INSTALL} source-highlight && good_msg "done" || bad_msg "Error installing source-highlight"
  fi
}

# Install vim and plugins
function install_vim {
  if [[ ! -x `which vim` ]]; then
    if [[ "$OSX" ]]; then
      brew install vim --with-lua
    else
      if [[ ! -x `which hg` ]]; then
        info_msg "Installing hg(Mercurial)"
        ${INSTALL} mercurial || exit 1
      fi
      if [[ ! -d "vim_src" ]]; then
          info_msg "Cloning vim repo"
          hg clone https://vim.googlecode.com/hg/ vim_src || exit 1
      fi
      cd vim_src
      info_msg "Installing Vim with python and ruby support"
      ./configure --prefix=/usr/local/ --enable-rubyinterp --enable-pythoninterp --enable-luainterp --with-features=huge || exit 1
      make || exit 1
      sudo make install || exit 1
    fi
  fi

  # backup dir
  info_msg -n "Creating backup vim directory..."
  mkdir -p vim/backup && good_msg "done" || warning_msg "Manually create the dir ~/.vim/backup"

  # Plugins
  if [[ ! -d $dir/vim/bundle/Vundle.vim/ ]]; then
    info_msg "Installing Vundle"
    if ! git clone https://github.com/gmarik/Vundle.vim.git vim/bundle/Vundle.vim ; then
      bad_msg "Error doing git clone..."
      exit 1
    fi
  fi

  vim +VundleInstall! +VundleClean +qall
}

####### Go ahead, call the functions #######

install_brew || exit 1
install_git || exit 1

if [ ! "$1" = -z ]; then
  install_zsh || exit 1
fi

install_vim || exit 1

install_more || exit 1

