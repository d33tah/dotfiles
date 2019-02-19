ZSH_THEME="linuxonly"
ZSH=$HOME/.oh-my-zsh

plugins=(git cp colorized colored-man compleat copyfiles copydir extract screen debian history-substring-search zsh-syntax-highlighting gitfast git-extras git-flow jsontools python vagrant)

source $ZSH/oh-my-zsh.sh

# User configuration

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd () {
dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%{$c4%}%/%{$c0%}(%{$c5%}%?%{$c0%})"
PROMPT='%{$fg_bold[red]%}[%*] $(git_prompt_info) %{$fg_bold[green]%}%p%{$reset_color%}${dir_status}${ret_status}%{$reset_color%} > '
}

source ~/.shrc
