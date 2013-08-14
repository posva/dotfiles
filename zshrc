# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="posva"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias tele="ssh sanmarte@telesun.imag.fr"
alias telex="ssh -Y sanmarte@telesun.imag.fr"
alias du="du -h"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras git-remote-branch gitfast gitflow lol nyan osx brew encode64 urltools rand-quote gem)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/texbin:/usr/local/bin:/usr/local/git/bin:/usr/bin:/usr/sbin:/opt/X11/bin:/bin:/sbin:/Users/Edu/.rvm/bin:/usr/local/share/npm/bin
#export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

autoload -U colors
colors

alias gource="gource --user-image-dir ~/gource-img/ --multi-sampling --dont-stop"

export TERM=xterm-256color

# zsh-completion from brew
fpath=(/usr/local/share/zsh-completions $fpath)
alias watch="nocorrect watch"
