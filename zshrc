export PYTHONIOENCODING=utf-8
setopt NO_BEEP

RM=`which rm`
function rm { if [ "$1" == "-rf" -a "$2" == "/" ]; then cowsay "No wai"; else $RM $@; fi }

#DODANE AUTOMATYCZNIE PRZEZ usos-python:
PATH=$HOME/bin:$PATH

set -o vi

alias killbg='for job in `jobs -l | egrep -o "([0-9][0-9]+)"`; do kill $job ; done'
alias sort='LC_ALL=C sort'

if [[ $TERM == screen ]]; then
echo "Jestes w screenie"
fi

export PYTHONPATH=/home/d33tah/lib/python2.5/site-packages
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


# zshrc  - ZSH Configuration file
# Author - Dawid Węgliński	<cla@gentoo.org>
# Credits - Some of this functions comes from zshwiki, some from .zshrc files
# i've found over the net. Also thanks for welp <welp at gentoo.org>, which from
# i've stollen url-quote-magic and ewho with ecd functions, which were stolen
# from ciaranm <ciaranm at ciaranm.org> ;)
# date - 24.07.2007
#
export ECHANGELOG_USER="Dawid Węgliński <cla@gentoo.org>"

# Prompt colors
local RED=$'%{\e[0;31m%}'
local GREEN=$'%{\e[0;32m%}'
local YELLOW='%{\e[0;33m%}'
local BLUE=$'%{\e[0;34m%}'
local PINK=$'%{\e[0;35m%}'
local CYAN=$'%{\e[0;36m%}'
local GREY=$'%{\e[1;30m%}'
local NORMAL=$'%{\e[0m%}'

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

#exporting prompt
if [[ ${UID} == "0" ]]; then
	promptinit 
	prompt gentoo
	#export PS1="$(print "${NORMAL}[${GREEN}%M${NORMAL}][${YELLOW}%~${NORMAL}]${RED} %(!.#.$) ${NORMAL}")"
else
	if [[ ${HOST} == "kolos" ]]; then
		#export PS1="$(print "${GREY}[${YELLOW}%~${GREY}]${YELLOW} %(!.#.$) ${NORMAL}")"
		#export PS1="$(print "${BLUE}[${GREEN}%~${BLUE}]${GREEN} %(!.#.$) ${NORMAL}")"
		#export PS1="$(print "${YELLOW}[${RED}%~${YELLOW}]${RED} %(!.#.$) ${NORMAL}")"
		#export PS1="$(print "${GREEN} %(!.#.>) ${NORMAL}")"
		export PS1="$(print "${RED}%(!.#.>) ${NORMAL}")"
	else
		export PS1="$(print "${GREY}[${YELLOW}%M${GREY}][${YELLOW}%~${GREY}]${YELLOW} %(!.#.$) ${NORMAL}")"
	fi
fi

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

# Create a shot of screen an place it in proper directory
shot() {
	[[ ! -d ~/shots ]] && mkdir ~/shots
	cd ~/shots
	[[ -z "$1" ]] && echo "Failed with no argument!" && return 
	scrot -cd 5 $(date +%Y_%m_%d_%H-%M)-$1.png
}

# List only file that are images
limg() {
	local -a images
	images=( *.{jpg,jpeg,gif,png,JPG,JPEG,GIF,PNG}(.N) )
	if [[ $#images -eq 0 ]] ; then
		print "No image files found."
	else
		ls "$@" "$images[@]"
	fi
}

status() {
	echo "Date..: $(date "+%Y-%m-%d %H:%M:%S")"
	echo "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
	echo "Term..: $TTY ($TERM), $BAUD bauds, $COLUMNS x $LINES cars"
	echo "Login.: $LOGNAME (UID = $EUID) on $HOST"
	echo "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
	echo "Uptime:$(uptime)"
}

google() {
	local str opt
		if [ $# != 0 ]; then
			for i in $*; do
				str="$str+$i"
			done
		str=`echo $str | sed 's/^\+//'` 
		opt='search?rls=pl&ie=utf-8&oe=utf-8'
		opt="${opt}&q=${str}"
          fi
echo "http://www.google.pl/${opt}"
}

# Create an index with thumbs. You will need media-gfx/imagemagick to make this
# script working.
genthumbs () {
	rm -rf thumb-* index.html
	echo "
<html>
  <head>
	<title>Images</title>
  </head>
  <body>" > index.html
	for f in *.(gif|jpeg|jpg|png)
	do
	    convert -size 100x200 "$f" -resize 100x200 thumb-"$f"
	    echo "    <a href=\"$f\"><img src=\"thumb-$f\"></a>" >> index.html
	done
	echo "
  </body>
</html>" >> index.html
}

# Make html file from plain/text
2html() {
	vim -n -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 > /dev/null 2> /dev/null
}

# Usefull for polish users only; shows tv program for few most watched tv
# programs
tv() {
	if [[ -n ${1} ]]; then
		case "${1}" in
			1) PROGRAM="TVP 1" ;;
			2) PROGRAM="TVP 2" ;;
			p) PROGRAM="Polsat" ;;
			t) PROGRAM="TVN" ;;
			4) PROGRAM="TV 4" ;;

		esac
	fi
	wget -q -O - http://www.gazeta.pl/tv/  | grep -E "c2c4c7|c7c2af" \
	| grep -v grot| grep -A 1 "${PROGRAM}"| html2text | iconv -f ISO8859-2 -t UTF-8
	unset PROGRAM
}

# Files with space in the name are evil!!!!!!!!
space_rm() {
	for file in *; do 
		mv ${file} ${file:gs/\ /_/}
	done
}

# Files with [:upper:] characters in the name are evil as well!
lowercase_mv() {
	for file in *; do
		mv ${file} ${file//(#m)[A-Z]/${(L)MATCH}}
	done
}

# Probably you will want to hash this 4 lines, or change host name
# To know what keychain is, please visit it's project page:
# http://www.gentoo.org/proj/en/keychain/
if [[ ${HOST} == "sapphire" && ${UID} != "0" ]]; then
	/usr/bin/keychain -q ~/.ssh/identity ~/.ssh/id_dsa
	source ~/.keychain/sapphire-sh
fi

# DIE SATANA!
die() {
	echo $1
	return 0
}

#show me the TODO file
#[ -e ~/TODO ] && < ~/TODO

# Speciall thanks for welp, however it's ciaranm's function as far as i know.
# This inspired me to write next function that is below. Moreover, i've
# modernized ecd, so now it shows available versions in the tree. Green color
# means that you don't have this version installed. Red one, with two asterisks
# means that this version is installed in your system
ecd() {
	local pc d file has

	pc=$(efind $*)
	d=$(eportdir)

	if [[ $pc == "" ]] ; then
	 echo "nothing found for $*"
	 return 1
	fi

	cd ${d}/${pc}
	if [[ -n "$1" ]]; then

	index=1
	for file in *.ebuild; do
		has="0"
		if [[ -d /var/db/pkg/${pc%/*}/${file%.ebuild} ]]; then
			   has="1"
		fi
		if [[ "${has}" == "1" ]]; then
			print "   [$fg[red]*${index}*$fg[default]]     ${file%.ebuild}"
		else
			print "   [$fg[green] ${index} $fg[default]]     ${file%.ebuild}"
		fi
		((index++))
	done
	fi
		
}

eportdir() {
	# does fast cache magic. portageq in particular is really slow...
	# this makes subsequent calls to eportdir() pretty much
	# instantaneous, as opposed to taking several seconds.
	if [[ -n "${PORTDIR_CACHE}" ]] ; then
	    echo "${PORTDIR_CACHE}"
	elif [[ -d "${HOME}"/gentoo/gentoo-x86 ]]; then
	    PORTDIR_CACHE="${HOME}"/gentoo/gentoo-x86 eportdir
	elif [[ -d /usr/portage ]] ; then
	    PORTDIR_CACHE="/usr/portage" eportdir
	else
	    PORTDIR_CACHE="$(portageq portdir )" eportdir
	fi
}

efind() {
	local efinddir cat pkg
	efinddir=$(eportdir)

	case $1 in
	    *-*/*)
	    pkg=${1##*/}
	    cat=${1%/*}
	    ;;

	    ?*)
	    pkg=${1}
	    cat=$(echo1 ${efinddir}/*-*/${pkg}/*.ebuild)
	    [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/${pkg}*/*.ebuild)
	    [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}/*.ebuild)
	    [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}*/*.ebuild)
	    if [[ ! -f $cat ]]; then
	        return 1
	    fi
	    pkg=${cat%/*}
	    pkg=${pkg##*/}
	    cat=${cat#${efinddir}/}
	    cat=${cat%%/*}
	    ;;
	esac

	echo ${cat}/${pkg}
}

echo1() {
	echo "$1"
}

updaterc() {
	wget http://dev.gentoo.org/~cla/.zshrc -O ${1}/.zshrc
}

# Check metadata files for herd and devs responsible for t3h package
ewho() {
	local pc d metadata f

	pc=$(efind $*)
	d=$(eportdir)
	f=0

	if [[ $pc == "" ]] ; then
	    echo "nothing found for $*"
	    return 1
	fi

	metadata="${d}/${pc}/metadata.xml"
	if [[ -f "${metadata}" ]] ; then
	    echo "metadata.xml says:"
	    sed -ne 's,^.*<herd>\([^<]*\)</herd>.*,  herd:  \1,p' \
	    "${metadata}"
	    sed -ne 's,^.*<email>\([^<]*\)@[^<]*</email>.*,  dev:   \1,p' \
	    "${metadata}"
	    f=1
	fi

	if [[ -d ${d}/${pc}/CVS ]] ; then
	    echo "CVS log says:"
	    pushd ${d}/${pc} > /dev/null
	    for e in *.ebuild ; do
	        echo -n "${e}: "
	        cvs log ${e} | sed -e '1,/^revision 1\.1$/d' | sed -e '2,$d' \
	        -e "s-^.*author: --" -e 's-;.*--'
	    done
	    popd > /dev/null
	    f=1
	fi

	if [[ f == 0 ]] ; then
	    echo "Nothing found"
	    return 1
	fi
	return 0
}
