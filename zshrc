local SALTED_HOSTNAME_MD5=$(echo 'saltysalt'`hostname` | md5sum | cut -f1 -d" ")
export PYTHONRC="$HOME/.pythonrc"

export PYTHONIOENCODING=utf-8
setopt NO_BEEP

PATH=$HOME/bin-scripts:$HOME/bin:$PATH

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

if [ "$SSH_CONNECTION" != "" ]; then
  if [[ $TERM != screen ]] && ! screen -x -SU wrapper; then
      if [[ $TERM != screen ]] && ! screen -x -SU main; then
      ssh-agent screen -c ~/.screenrc-wrapper -SU wrapper screen -SU main
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
unsetopt equals


if [ "$SALTED_HOSTNAME_MD5" == "793e4a1cceaa5571857b2c3c18955758" ]; then
  local COLOR=${YELLOW}
  export NMAP_PRIVILEGED="1"
fi

if [ "$SALTED_HOSTNAME_MD5" == "77ad4a3076ca39632f7dd5009a60ca7d" ]; then
  local COLOR=${BRIGHTYELLOW}
fi

if [ "$SALTED_HOSTNAME_MD5" == "f4781443172a938c1d706088c1d3d625" ]; then
  export NMAP_PRIVILEGED="1"
fi

export PS1="$(print "${GREY}[${COLOR}%*${GREY}][${COLOR}%~${GREY}]${COLOR}%(?..${BLINK}[%?]${COLOR} )%(!.#.$) ${NORMAL}")"

#exporting colors
export GREP_COLOR=31

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
export HISTSIZE=500000
export HISTFILE=~/.history_zsh
export SAVEHIST=400000

# of course
export EDITOR="/usr/bin/vim"

# Key Bindings
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

case $TERM in (xterm*)
        bindkey "\e[H" beginning-of-line
        bindkey "\e[F" end-of-line
esac
bindkey "\e[3~" delete-char
