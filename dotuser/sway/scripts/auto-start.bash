#!/bin/bash
swaymsg workspace 1 && swaymsg exec 'xfce4-terminal -x notes.bash'
sleep 2

swaymsg workspace 2 && swaymsg exec gtk-launch firefox-dev.desktop
sleep 2

swaymsg workspace 3 && swaymsg exec gtk-launch firefox-esr.desktop
sleep 2

