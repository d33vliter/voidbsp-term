#!/usr/bin/env bash

#Monitor
xrandr --dpi 94

#wallpaper
pkill nitrogen
nitrogen --restore

#picom
pkill picom
picom -f -D 2 & 

#clipit
pkill parcellite
parcellite &

#Numkey
numlockx on

#Cursor
xsetroot -cursor_name left_ptr

#Keyboard
setxkbmap -layout us -variant intl

#polkit
pkill /usr/bin/lxpolkit
/usr/bin/lxpolkit &
