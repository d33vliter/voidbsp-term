# .bashrc
eval "$(zoxide init bash)"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias o='find -type f | fzf --print0 | xargs --null xdg-open'
alias v='vim $(find ~ -type f | fzf)'
alias cat='bat $(find ~ -type f | fzf)'
alias c='z $(find ~ -type d | fzf)'
alias cc='z $(find  -type d | fzf)'
