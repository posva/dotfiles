#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles               # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc oh-my-zsh"    # list of files/folders to symlink in homedir

##########

# Verification of the install dir
if [[ ! "$(cd `dirname $0` && pwd)" == "$dir" ]]; then
  echo "The dotfiles repo is at a wrong place. It should be at $dir"
  exit 1
fi

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~ ..."
rm -rf $olddir
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    if [ -f ~/.$file -o -d ~/.$file ]; then
        echo "moved $file"
        mv -f ~/.$file $olddir
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

function install_zsh {
# Test to see if zshell is installed.  If it is:
if which zsh >/dev/null; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        echo "Cloning oh-my-zsh"
        git clone https://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        if [ ! "$(grep $(which zsh) /etc/shells)" ]; then
            sudo echo "$(which zsh)" >> /etc/shells
        fi
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
        # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        if which brew >/dev/null; then
            echo "Installing Homebrew(brew)..."
            ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
            echo "done"
        fi
        echo "Installing zsh..."
        brew install zsh
        echo "done"
        install_zsh
        exit
    fi
fi
}

install_zsh

# Install posva zsh theme
zsh_theme="oh-my-zsh/themes/posva.zsh-theme"
if [ ! -f $zsh_theme ]; then
    echo "Installing zsh theme..."
    wget -q https://raw.github.com/posva/oh-my-zsh/6e611f2f45320eef572d13fc3c57391fd0beedb3/themes/posva.zsh-theme -O $zsh_theme
    echo "done"
fi

echo "Creating backup vim directory..."
mkdir -p vim/backup
echo "done"

if [[ ! -d $dir/vim/bundle/vundle/ ]]; then
  echo "Installing Vundle"
  git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
  echo "done"
fi

if which vim >/dev/null; then
    vim -c "BundleInstall"
else
    echo "Install vim with python suppoort and then run \"vim -c BundleInstall\""
fi
