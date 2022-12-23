alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '



#alias personalizados
alias v='vim $(find ~ -type f | fzf)'
alias bat='bat $(find ~ -type f | fzf)'
alias c='z $(find ~ -type d | fzf)'
alias cc='z $(find -type d | fzf)'
alias rmf='rm -rfI $(ls | fzf -m)'
alias rmc='rm -rfI $(find | fzf -m)'

#Exports personalizados
#fzf.vim
export FZF_DEFAULT_COMMAND="find ~ -type f"

#pfetch
export PF_INFO="ascii title os host kernel uptime pkgs memory editor shell wm"


#Eval Personalizados
#zoxide necesario para el comando c
eval "$(zoxide init bash)"



#FUNCIONES
extraer () {
    if [ -f $1 ] ; then
            case $1 in
            *.tar.bz2)    tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.tar.xz)    tar xf $1      ;;
            *.bz2)        bunzip2 $1     ;;
            *.rar)        unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)        tar xvf $1     ;;
            *.tbz2)        tar xvjf $1    ;;
            *.tgz)        tar xvzf $1    ;;
            *.zip)        unzip $1       ;;
            *.Z)        uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)        echo "don't know how to extract '$1'..." ;;
            esac
    else
            echo "'$1' is not a valid file!"
    fi
 }
