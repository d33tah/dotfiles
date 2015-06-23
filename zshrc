local SALTED_HOSTNAME_MD5=$(echo 'saltysalt'`hostname` | md5sum | cut -f1 -d" ")
export PYTHONRC="$HOME/.pythonrc"

export PYTHONIOENCODING=utf-8
setopt NO_BEEP

export PATH=$HOME/.nmap:$HOME/bin-scripts:$HOME/bin:$PATH
export MANPATH=`manpath`:$HOME/.nmap/docs # add a symlink to man1 there
alias nmapp='nmap --script="default,external,safe and not http-slowloris-check"'

set -o vi

alias killbg='for job in `jobs -l | egrep -o "([0-9][0-9]+)"`; do kill $job ; done'
alias sort='LC_ALL=C sort'

if [[ $TERM == screen ]]; then
echo "Jestes w screenie"
fi

export LC_ALL=en_US.UTF-8

bindkey "5C" forward-word
bindkey "5D" backward-word

if [ -f ~/.github-token ]; then
  source ~/.github-token
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1
if [ -f ~/virtualenv/bin/activate ]; then
    source ~/virtualenv/bin/activate
fi

if [ "$SSH_CONNECTION" != "" ]; then
  if echo $TERM | grep -v 'screen' && ! screen -x -SU wrapper; then
      if echo $TERM | grep -v 'screen' && ! screen -x -SU main; then
      screen -c ~/.screenrc-wrapper -SU wrapper ssh-agent screen -SU main
      fi
  fi
fi

# Prompt colors
RED=$'%{\e[0;31m%}'
GREEN=$'%{\e[0;32m%}'
YELLOW='%{\e[0;33m%}'
BRIGHTYELLOW='%{\e[1;33m%}'
BLUE=$'%{\e[0;34m%}'
PINK=$'%{\e[0;35m%}'
CYAN=$'%{\e[0;36m%}'
GREY=$'%{\e[1;30m%}'
NORMAL=$'%{\e[0m%}'
BLINK=$'%{\e[0;5m%}'

function gen_words() {
    LC_ALL="$1" aspell dump master  | iconv -f latin2 -t utf-8 | cut -d'/' -f1
};

function gen_pass() {
    sort -R <( gen_words "pl" ) <( gen_words "en_US" ) | uniq | tail -n30
}

# completion
autoload -U complist compinit promptinit tetris zcalc url-quote-magic colors
compinit
colors

#compdef _pkglist ecd

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
#zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zle '-N' tetris
zle '-N' url-quote-magic
bindkey '^T' tetris
bindkey "\e" backward-delete-word
bindkey '^R' history-incremental-search-backward
export WORDCHARS='*?_[]~\!#$%^<>|`@#$%^*()+?'

setopt notify correct
setopt correctall autocd
setopt short_loops
setopt nohup
setopt extended_history
setopt extendedglob
setopt interactivecomments
setopt hist_ignore_all_dups
setopt auto_remove_slash
setopt short_loops
setopt nonomatch
unsetopt equals

# If there is Nmap installed but it has no cap_net_raw for me.
if nvim --version >/dev/null 2>&1; then
  alias vim=nvim
  export EDITOR=`which nvim`
else
  export EDITOR=`which vim`
  vim --version >/dev/null 2>&1 || echo "No vim found."
fi

if nmap --version >/dev/null && getcap `which nmap` | grep -q cap_net_raw; then
  export NMAP_PRIVILEGED="1"
else
  echo "WARNING: No Nmap with cap_net_raw in \$PATH!" >&2
fi

# Set special PS1 colors for some of my boxes.
if [ "$SALTED_HOSTNAME_MD5" == "793e4a1cceaa5571857b2c3c18955758" ]; then
  local COLOR=${YELLOW}
fi

if [ "$SALTED_HOSTNAME_MD5" == "77ad4a3076ca39632f7dd5009a60ca7d" ]; then
  local COLOR=${BRIGHTYELLOW}
fi

# d33tah's prompt. Example:
#
# (virtualenv)[ACL][x:S8:U1:2][15:06:08][~/workspace/nmap/nmap-exp/d33tah/nmap-nsock-scan][1]$

# Explanation:
#
# (virtualenv) is the current python virtualenv.
# [ACL] shows when there might be any interesting ACL entries for this directory.
# [x:S8:U1:2] says that I'm on a git branch x with 8 stashes, 1 unpushed commit and 2 files shown by --git-status.
# The time is there in order to be able to tell how long the commands ran.
# [1] is the error code of the previous command.
# If the user is root, the $ will become #.
#
# I tried to make the Git and ACL prompt display as little as possible when
# there was no interesting information found.

setopt PROMPT_SUBST



function virtualenv_prompt() {

  if [ "$VIRTUAL_ENV" != "" ]; then
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        echo "[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
    else
        echo "(`basename \"$VIRTUAL_ENV\"`)"
    fi
  fi
}

local detect_acl='$( [ `getfacl . | wc -l` -ne 7 ] && echo -n "[ACL]" )'

function git_prompt() {
    if git status >/dev/null 2>&1; then # are we in a git directory?
        echo -n "["

        BRANCH_NAME=`git symbolic-ref --short HEAD 2>/dev/null`
        if [ "$BRANCH_NAME" != "master" ]; then
          echo -n "$BRANCH_NAME:"
        fi

        STASH_COUNT=`git stash list | wc -l`
        if [ "$STASH_COUNT" != "0" ]; then
          echo -n "S$STASH_COUNT:"
        fi

        UNPUSHED_COUNT=`git log --format=oneline \"$(git unpushed-range 2>/dev/null)\" 2>/dev/null | wc -l`
        if [ "$UNPUSHED_COUNT" != "0" ]; then
            echo -n "U${UNPUSHED_COUNT}:"
        fi

        CHANGED_FILES=`git status --porcelain | wc -l`
        if [ "$CHANGED_FILES" != "0" ]; then
            CHANGED_TRACKED_FILES=`git status --porcelain | grep '^[^?][^?]' | wc -l`
            echo -n "$CHANGED_TRACKED_FILES/$CHANGED_FILES"
        fi

        echo -n "]"
    fi
}

export PS1='$( virtualenv_prompt )'"${detect_acl}"'$( git_prompt )'"$(print "${GREY}[${COLOR}%*${GREY}][${COLOR}%~${GREY}]${COLOR}%(?..${BLINK}[%?]${COLOR} )%(!.#.$) ${NORMAL}")"

#exporting colors
export GREP_COLOR=31
export MYSQL_PS1="[\D]> "

#aliases
alias ls="ls --color=auto --classify $*"
alias grep='grep --color=auto'

alias 7zr=7z
alias 7zbrute="7zr a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on"
alias 7zultra="7zr a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on"

alias nconf='./configure --without-ndiff --without-zenmap  --without-nping --without-ncat --without-nmap-update'
export MAKEFLAGS=-j`nproc`

function psp {
ffmpeg -y -i $1 -flags +bitexact -s  400x192 -r 29.97 -b:v 512k -acodec libfaac -b 672k -ab 96k -ar 24000 -f psp -strict -2 $1.mp4
}

alias ds='diffstat'

#global aliases
alias -g '...'='../..'
alias -g '....'='../../..'

if [[ -f ~/.ssh/known_hosts ]]; then
    _myhosts=(${${${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*}#\[}/]:*/})
    zstyle ':completion:*' hosts $_myhosts
fi

#colors
if [[ -f ~/.dir_colors ]]; then
        eval `dircolors -b ~/.dir_colors`
else
    if [[ -f /etc/DIR_COLORS ]]; then
        eval `dircolors -b /etc/DIR_COLORS`
    fi
fi

#umask 022

watch=all
logcheck=30
WATCHFMT="User %n has %a on tty %l at %T %W"

# Display path in titlebar of terms.
[[ -t 1 ]] || return
    case $TERM in
            *xterm*|*rxvt*|(dt|k|E)term)
            precmd() {
                    print -Pn "\e]2;[%n] : [%m] : [%~]\a"
                }
        preexec() {
            print -Pn "\e]2;[%n] : [%m] : [%~] : [ $1 ]\a"
            }
    ;;
    esac

# History
export HISTSIZE=5000000
export HISTFILE=~/.history_zsh
export SAVEHIST=4000000

# Key Bindings
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

case $TERM in (xterm*)
        bindkey "\e[H" beginning-of-line
        bindkey "\e[F" end-of-line
esac
bindkey "\e[3~" delete-char

alias mow='rlwrap espeak -v pl'
alias nmap-quiet='nmap -Pn -n'
alias shred-zero='shred -uvzn0'
