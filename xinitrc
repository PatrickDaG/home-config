#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xrdb load "${HOME}/.Xresources"
xset r rate 235 60
xset m 1 0
# numlockx on
syndaemon -d -i 1.2 -t -K
xsetroot -solid '#000000'
setxkbmap de bone
autorandr -c
xgamma -gamma 1
echo disabled > /sys/bus/usb/devices/1-1/power/wakeup

touchegg &

gpg-connect-agent "\bye" &
dunst &
exec dbus-launch --sh-syntax --exit-with-session -- herbstluftwm --locked
# exec icewm-session
