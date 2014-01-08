export PYTHONIOENCODING=utf-8
setopt NO_BEEP


PATH=$HOME/bin:$PATH

set -o vi

alias killbg='for job in `jobs -l | egrep -o "([0-9][0-9]+)"`; do kill $job ; done'
alias sort='LC_ALL=C sort'

if [[ $TERM == screen ]]; then
echo "Jestes w screenie"
fi

export LC_ALL=en_US.UTF-8

bindkey "5C" forward-word
bindkey "5D" backward-word

#source ~/.github-token

if false; then
#if [[ $TERM != screen ]] && ! screen -x -SU wrapper; then
    if [[ $TERM != screen ]] && ! screen -x -SU main; then
    screen -SU main
    fi
fi

#if [[ $TERM != screen ]] && ! screen -x -SU wrapper; then
#screen -SU wrapper -c ~/.screenrc-wrapper screen -SU main
#fi


# Prompt colors
local RED=$'%{\e[0;31m%}'
local GREEN=$'%{\e[0;32m%}'
local YELLOW='%{\e[0;33m%}'
local BLUE=$'%{\e[0;34m%}'
local PINK=$'%{\e[0;35m%}'
local CYAN=$'%{\e[0;36m%}'
local GREY=$'%{\e[1;30m%}'
local NORMAL=$'%{\e[0m%}'
local BLINK=$'%{\e[0;5m%}'

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

typeset -A abbreviations
abbreviations=(
  "Im"    "| more"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ieg"   "| egrep"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "It"    "| tail"
  "Is"    "| sort"
  "Iw"    "| wc"
  "Ix"    "| xargs"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
#bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

local COLOR=${YELLOW}
export PS1="$(print "${GREY}[${COLOR}%*${GREY}][${COLOR}%~${GREY}]${COLOR}%(?..${BLINK}[%?]${COLOR} )%(!.#.$) ${NORMAL}")"

#exporting colors
export GREP_COLOR=31

#aliases
alias ls="ls --color=auto --classify $*"
alias grep='grep --color=auto'

alias 7zr=7z
alias 7zbrute="7zr a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on"
alias 7zultra="7zr a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on"
alias psp="ffmpeg -y -i -flags +bitexact -s  400x192 -r 29.97 -b:v 512k -acodec libfaac -b 672k -ab 96k -ar 24000 -f psp -strict -2"

alias u='time { sudo emerge --sync && sudo emerge -uDNva world }'

alias ds='diffstat'

#global aliases
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g M="| more"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"

# some variables for openssh
#users=(cla root ircdwww claudiush clsh odysei)
#zstyle ':completion:*' users $users

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
