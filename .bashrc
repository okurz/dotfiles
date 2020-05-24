# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Append history list instead of override
shopt -s histappend
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# All commands of root will have a time stamp
if test "$UID" -eq 0  ; then
    HISTTIMEFORMAT=${HISTTIMEFORMAT:-"%F %H:%M:%S "}
fi
# Force a reset of the readline library
unset TERMCAP

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

alias printable="sed -e 's/[^[:print:]\n\r]//g'"
alias latest="ls -w 1 -tr | tail -n 1"
alias crnl_fix="sed 's/\r$//'"
cpu_nr=$((`grep processor /proc/cpuinfo | wc -l`+2))
alias makej="make -j$cpu_nr"

export CTEST_OUTPUT_ON_FAILURE=1
# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

alias pip-opt-install='pip install --install-option="--prefix=/opt"'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

cpu_nr=$[`grep processor /proc/cpuinfo | awk '{print $3}' | tail -n 1`+2]
alias mj='make -j$cpu_nr'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# useful color definitions
BLACK='\[\e[0;30m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
PURPLE='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
WHITE='\[\e[0;37m\]'
BLACK_BOLD='\[\e[1;30m\]'
RED_BOLD='\[\e[1;31m\]'
GREEN_BOLD='\[\e[1;32m\]'
YELLOW_BOLD='\[\e[1;33m\]'
BLUE_BOLD='\[\e[1;34m\]'
PURPLE_BOLD='\[\e[1;35m\]'
CYAN_BOLD='\[\e[1;36m\]'
WHITE_BOLD='\[\e[1;37m\]'
BLACK_UNDERLINE='\[\e[4;30m\]'
RED_UNDERLINE='\[\e[4;31m\]'
GREEN_UNDERLINE='\[\e[4;32m\]'
YELLOW_UNDERLINE='\[\e[4;33m\]'
BLUE_UNDERLINE='\[\e[4;34m\]'
PURPLE_UNDERLINE='\[\e[4;35m\]'
CYAN_UNDERLINE='\[\e[4;36m\]'
WHITE_UNDERLINE='\[\e[4;37m\]'
BLACK_BACKGROUND='\[\e[41m\]'
RED_BACKGROUND='\[\e[41m\]'
GREEN_BACKGROUND='\[\e[42m\]'
YELLOW_BACKGROUND='\[\e[43m\]'
BLUE_BACKGROUND='\[\e[44m\]'
PURPLE_BACKGROUND='\[\e[45m\]'
CYAN_BACKGROUND='\[\e[46m\]'
WHITE_BACKGROUND='\[\e[47m\]'
COLOR_RESET='\[\e[0m\]' # Text Reset

ESCAPED_GREEN="\\[\\e[32m\\]"
ESCAPED_RED="\\[\\e[31m\\]"
ESCAPED_COLOR_RESET="\\[\\e[0m\\]"

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=...
#
# Additional stuff:
# - return status as number with color
# - last command number
# - current git branch if in a git repository
##################################################
bash_prompt_command() {
    # return status
    local RET_VALUE=$?
    #if [ $RET_VALUE -eq 0 ]; then
    #    RET_STATUS="${ESCAPED_GREEN}${RET_VALUE}${ESCAPED_COLOR_RESET}"
    #else
    #    RET_STATUS="${ESCAPED_RED}${RET_VALUE}${ESCAPED_COLOR_RESET}"
    #fi
    #RET_STATUS="$RET_STATUS $RET_SMILEY"
    RET_COLOR="\`[ $RET_VALUE = "0" ] && echo $ESCAPED_GREEN || echo $ESCAPED_RED\`"

    #JOB='[\!]'

    # How many characters of the $PWD should be kept
    #local pwdmaxlen=25
    local pwdmaxlen=50
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi

    # If this is an xterm set the title to user@host:dir
    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u@\h: ${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac

    local UC=$W                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

   # The following would be nicer but only works on some shells, maybe debian
   # only? The second command always works but might be a bit less efficient
   if [ -f /etc/debian_version ]; then
        local GIT_BRANCH="\$(__git_ps1)"
   else
        local GIT_BRANCH="\$(git branch --no-color 2> /dev/null | sed -n -e 's/* \(.*\)/ (\1)/p')"
   fi


    # extra backslash in front of \$ to make bash colorize the prompt

    #PS1="${TITLEBAR}${debian_chroot:+($debian_chroot)}${YELLOW}${JOB}${GREEN_BOLD}\u@\h${COLOR_RESET}:${BLUE_BOLD}\${NEW_PWD}${COLOR_RESET} ${RET_COLOR}${RET_VALUE}${YELLOW}${GIT_BRANCH}${COLOR_RESET} \$ "
    # I have n't used job number so far, so skip it
    PS1="${TITLEBAR}${debian_chroot:+($debian_chroot)}${GREEN_BOLD}\u@\h${COLOR_RESET}:${BLUE_BOLD}\${NEW_PWD}${COLOR_RESET} ${RET_COLOR}${RET_VALUE}${YELLOW}${GIT_BRANCH}${COLOR_RESET} \$ "
}

PROMPT_COMMAND=bash_prompt_command

case "$BASH_VERSION" in
[2-9].*)
    if test -e /etc/bash_completion ; then
	. /etc/bash_completion
    elif test -s /etc/profile.d/bash_completion.sh ; then
	. /etc/profile.d/bash_completion.sh
    elif test -s /etc/profile.d/complete.bash ; then
	. /etc/profile.d/complete.bash
    fi
    for s in /etc/bash_completion.d/*.sh ; do
	test -r $s && . $s
    done
    if test -e $HOME/.bash_completion ; then
	. $HOME/.bash_completion
    fi
    COMMAND_NOT_FOUND_AUTO=true
    if test -f /etc/bash_command_not_found ; then
	. /etc/bash_command_not_found
    fi
    ;;
*)  ;;
esac

hub_completion=${HOME}/local/hub-linux-amd64-2.2.2/etc/hub.bash_completion.sh
[ -f $hub_completion ] && . $hub_completion

todo_completion=documents/Computer/todo.txt/todo.txt-cli/todo_completion
[ -f $todo_completion ] && . $todo_completion
complete -F _todo t

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
# bash
# No ttyctl, so we need to save and then restore terminal settings
vim() {
    # osx users, use stty -g
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

#. ~/perl5/perlbrew/etc/bashrc

# Neo:                          # Neo Tastaturbelegung
PATH=$PATH:/home/krz/.neo/    # Neo Tastaturbelegung
#asdf -q                            # Neo Tastaturbelegung; mit einem # am Zeilenanfang bleibt QWERTZ das Standardlayout, sonst ist es Neo
#neo2

# Enable colorizing diagnostics of GCC
# https://gcc.gnu.org/gcc-4.9/changes.html
export GCC_COLORS

PATH=$PATH:$HOME/documents/Computer/todo.txt/todo.txt-cli

# replaced by script in ~/bin/neo2
#alias neo2='setxkbmap lv && xmodmap ~/Dokumente/Computer/KeyboardLayouts/Neo2/neo_de.xmodmap'

set_perl_path() {
    local version="$1"
    PATH="${HOME}/perl${version}/bin${PATH+:}${PATH}"; export PATH && PERL5LIB="${HOME}/perl${version}/lib/perl5${PERL5LIB+:}${PERL5LIB}" && export PERL5LIB && PERL_LOCAL_LIB_ROOT="${HOME}/perl${version}${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}" && export PERL_LOCAL_LIB_ROOT && PERL_MB_OPT="--install_base \"${HOME}/perl${version}\"" && export PERL_MB_OPT && PERL_MM_OPT="INSTALL_BASE=${HOME}/perl${version}" && export PERL_MM_OPT && PATH=$HOME/perl${version}/bin:$HOME/perl${version}/perlbrew/bin:$PATH
}
perl -v | grep 'version 26' >/dev/null && set_perl_path "5.26"
perl -v | grep 'version 18' >/dev/null && set_perl_path "5.18"

# http://guides.rubygems.org/faqs/#user-install
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export PATH
# make modified PATH available to user systemd services
# https://wiki.archlinux.org/index.php/Systemd/User
systemctl --user import-environment PATH

# added by travis gem
[ -f ${HOME}/.travis/travis.sh ] && . ${HOME}/.travis/travis.sh

# http://wiki.bash-hackers.org/scripting/debuggingtips
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

### the following is from https://raw.githubusercontent.com/nachoparker/xcol/xcol_bash/xcol.sh
# and uses xcolorize from https://fam.tuwien.ac.at/~schamane/_/mycolorize
#!/bin/bash
# Simple colorize for bash by means of sed
#
# Copyright 2008-2015 by Andreas Schamanek <andreas@schamanek.net>
#
# 2017 - Modified from mycolorize into a shell function 
#     by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
#
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage examples:
#   tail -f somemaillog | xcolorize white '^From: .*' bell
#   tail -f somemaillog | xcolorize white '^From: \/.*' green 'Folder: .*'
#   tail -f somemaillog | xcolorize --unbuffered white '^From: .*'
#
# Notes:
#   Regular expressions need to be suitable for _sed --regexp-extended_
#   Slashes / need no escaping (we use ^A as delimiter).
#   \/ splits the coloring (similar to procmailrc. Matches behind get color.
#   Even "white '(for|to) \/(her|him).*$'" works :) Surprisingly ;)
#   To color the string '\/' use the regular expression '\\()/'.
#   If the 1st argument is -u or --unbuffered, _sed_ will be run so.

# For the colors see tput(1) and terminfo(5), or e.g.
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# and http://stackoverflow.com/a/20983251/196133

function xcolorize()
{
  local bold=$(tput bold)                         # make colors bold/bright
  local normal=$'\e[0m'                           # (works better sometimes)

  local red="$bold$(tput setaf 1)"                # bright red text
  local green=$(tput setaf 2)                     # dim green text
  local fawn=$(tput setaf 3); beige="$fawn"       # dark yellow text
  local yellow="$bold$fawn"                       # bright yellow text
  local darkblue=$(tput setaf 4)                  # dim blue text
  local blue="$bold$darkblue"                     # bright blue text
  local purple=$(tput setaf 5); magenta="$purple" # magenta text
  local pink="$bold$purple"                       # bright magenta text
  local darkcyan=$(tput setaf 6)                  # dim cyan text
  local cyan="$bold$darkcyan"                     # bright cyan text
  local gray=$(tput setaf 7)                      # dim white text
  local darkgray="$bold"$(tput setaf 0)           # bold black = dark gray text
  local white="$bold$gray"                        # bright white text

  local bell=$(tput bel)                          # bell/beep
  local y=0

  # Make output unbuffered? (Pass argument -u|--unbuffered to _sed_.)
  if [ "/$1/" = '/-u/' -o "/$1/" = '/--unbuffered/' ] ; then
    local UNBUFFERED='-u'; shift
  else
    local UNBUFFERED=""
  fi

  # produce separator character ^A (for _sed_)
  local A=$(echo | tr '\012' '\001')

  # compile all rules given at command line to 1 set of rules for SED
  while [ "/$1/" != '//' ] ; do
    local c1=''; local re='';  local beep=''
    c1=$1 ; re="$2" ; shift 2 || break
    # if a beep is requested in the optional 3rd parameter set $beep
    [ "/$1/" != '//' ] && [[ ( "$1" = 'bell' || "$1" = 'beep' ) ]] \
      && beep=$bell && shift
    # if the regular expression includes \/ we split the substitution
    if [ "/${re/*\\\/*/}/" = '//' ] ; then
      # we need to count "("s before the \/ (=$left)
      local left="${re%\\/*}"; local leftlength=${#left}
      # first we count "\("
      local dummy=${left//\\(}; escdgroups=$(( (leftlength-${#dummy})/2 ))
      # now "(" (and we add 2 for the groups used for ($re) in $sedrules)
      local dummy=${left//(}; groupcnt=$((leftlength-${#dummy}-escdgroups+2))
      # replace \/ with )( so below we get (left-re)(right-re)
      re="${re/\\\//)(}"
      local sedrules="$sedrules;s$A($re)$A\1${!c1}\\$groupcnt$beep$normal${A}g"
      sedrules="${sedrules}I"   # add case insensitive
    else
      local sedrules="$sedrules;s$A($re)$A${!c1}\1$beep$normal${A}g"
      sedrules="${sedrules}I"   # add case insensitive
    fi
    # limit parsing of arguments
    (( y++ && y>888 )) && { echo "$0: too many arguments" >&2; return 1; }
  done

  # call sed to do the main job
  sed $UNBUFFERED --regexp-extended -e "$sedrules"

  return
}

# Colorize your standard output using xcolorize with a grep-like usage
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage piping from stdin:
#   mount | xcol mnt "sda." "sdb." cgroup tmpfs proc
#
# Usage reading from a file:
#   xcol pae fpu vme mhz sse2 cache cores /proc/cpuinfo
#
# Notes:
#   It supports sed compatible regular expressions
function xcol()
{
  local bold=$(tput bold)                         # make colors bold/bright
  local red="$bold$(tput setaf 1)"                # bright red text
  local green=$(tput setaf 2)                     # dim green text
  local fawn=$(tput setaf 3); beige="$fawn"       # dark yellow text
  local yellow="$bold$fawn"                       # bright yellow text
  local darkblue=$(tput setaf 4)                  # dim blue text
  local blue="$bold$darkblue"                     # bright blue text
  local purple=$(tput setaf 5); magenta="$purple" # magenta text
  local pink="$bold$purple"                       # bright magenta text
  local darkcyan=$(tput setaf 6)                  # dim cyan text
  local cyan="$bold$darkcyan"                     # bright cyan text
  local gray=$(tput setaf 7)                      # dim white text
  local darkgray="$bold"$(tput setaf 0)           # bold black = dark gray text
  local white="$bold$gray"                        # bright white text

  local COLS=( white yellow red cyan gray purple pink fawn )

  [ -t 0 ] && local STDIN=0 || local STDIN=1

  if [[ $STDIN == 0 ]]; then 
    local ARGVS=${@: 1 : $#-1 }                   # all arguments except last one
    local FILE=${@: -1}                           # last argument is the file name
  else
    local ARGVS=$@;
  fi

  local IDX=1                                     # rotate colors in a cycle
  for arg in ${ARGVS[@]}; do
    local ARGS=( ${ARGS[@]} ${COLS[$IDX]} $arg )
    IDX=$(( IDX + 1 )) 
    [[ $IDX == ${#COLS[@]} ]] && IDX=1
  done
  [[ $STDIN == 1 ]] && {
    xcolorize --unbuffered ${ARGS[@]}
    } || {
    cat $FILE | xcolorize --unbuffered ${ARGS[@]}
  }
}
# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

prove() {
    unbuffer $(which prove) --color $* | xcolorize --unbuffered green '^\s*ok [[:digit:]] - .*$' red 'not ok [[:digit:]]* - .*$'
}
