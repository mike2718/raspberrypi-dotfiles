#!/usr/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
#shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w [\D{%R %A,%e %B %Y}]\n($?) \$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#### ??????????????????

# PATH??????

if [[ $UID -ge 1000 && -d $HOME/bin && -z $(echo "$PATH" | grep -o "$HOME/bin") ]]; then
    export PATH=$HOME/bin:${PATH}
fi
if [[ $UID -ge 1000 && -d $HOME/.local/bin && -z $(echo "$PATH" | grep -o "$HOME/.local/bin") ]]; then
    export PATH=$HOME/.local/bin:${PATH}
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# clang
export PATH=/usr/local/clang_15.0.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/clang_15.0.0/lib/aarch64-unknown-linux-gnu:/usr/local/clang_15.0.0/lib:$LD_LIBRARY_PATH

# ????????????????????????????????????
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export PROMPT_COMMAND='history -a; history -c; history -r' # ?????????????????????????????????

# Mimic Zsh run-help ability
run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'

# Disable Ctrl+z in terminal
trap "" SIGTSTP

# Auto "cd" when entering just a path
shopt -s autocd

# Prevent overwrite of files
set -o noclobber

# Shell exits even if ignoreeof set
export IGNOREEOF=100

#???Ctrl+S?????????????????????
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

# ???????????????
export VISUAL="/usr/bin/vim"
export EDITOR="/usr/bin/vim"
export SUDO_EDITOR="/usr/bin/vim"
export PAGER="/usr/bin/less"

# curl?????????????????????????????????
#export http_proxy="http://127.0.0.1:7890"
#export HTTPS_PROXY="http://127.0.0.1:7890"
# ????????????
#export https_proxy="http://127.0.0.1:7890"
#export HTTP_PROXY="${http_proxy}"

# rar????????????
#export RAR='-m5 -rr5 -s -md128 -ol'

# gnupg tty
GPG_TTY=$(tty)
export GPG_TTY

umask 002

# direnv??????
eval "$(direnv hook bash)"

# vim?????????
# vim: set et sw=4 sts=4 tw=80 ft=sh:
