#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Apply theme color to new terminals
(cat ~/.cache/wal/sequences &)


#if [ -e /usr/share/terminfo/x/xterm-256color ]; then
#  export TERM='xterm-256color'
#else
#  export TERM='xterm-color'
#fi

alias ls='ls --color=auto'

# Put all alias definitions in bash_aliases
source ~/.bash_aliases

# CD Path for acad
export CDPATH=".:/home/justin/acad:/home/justin/acad/f18:/home/justin/projects"

# Specify editor
export VISUAL=vim
export EDITOR=vim

bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'TAB:menu-complete'

export GPG_TTY=$(tty)

# Cargo bin
PATH="$HOME/.cargo/bin:$PATH"

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
RUBY="${HOME}/.gem/ruby/2.5.0/bin"
PATH="$RUBY:$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''

man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

coco() {
  java -jar /home/justin/acad/f18/cmsc420/jcoco/JCoCo/dist/JCoCoStudent.jar $*
}

