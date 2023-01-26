alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

#alias personalizados
alias d='dragon-drop -a -x "$(ls -r | fzf -m)"'
alias v='vim $(find ~ -type f | fzf)'
alias bat='bat $(find ~ -type f | fzf)'
alias rmf='rm -rfI $(ls | fzf -m)'
alias rmc='rm -rfI $(find | fzf -m)'

#Exports personalizados
#fzf.vim
export FZF_DEFAULT_COMMAND="find -type f -not -path '*/\.git/*'"

#pfetch
export PF_INFO="ascii title os host kernel uptime pkgs memory editor shell wm"

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
