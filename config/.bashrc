# .bashrc
eval "$(zoxide init bash)"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#abrir archivo
alias o='find -type f | fzf --print0 | xargs --null xdg-open'

#vim
alias v='vim $(find ~ -type f | fzf)'

#cat :v
alias cat='bat $(find ~ -type f | fzf)'

#cd en cualquier lugar del home
alias c='z $(find ~ -type d | fzf)'

#cd sobre carpeta actual
alias cc='z $(find -type d | fzf)'

#lo mismo de arriba pero con eliminar
alias rmf='rm -rfI $(find ~ | fzf -m)'
alias rmc='rm -rfI $(find | fzf -m)'
