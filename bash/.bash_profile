# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

if [[ "$(tty)" == "/dev/tty1" ]]
 then
  startx
fi
