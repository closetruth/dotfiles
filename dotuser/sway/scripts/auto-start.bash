#!/bin/bash
swaymsg workspace 1 && swaymsg exec 'xfce4-terminal -x notes.bash'
sleep 1

swaymsg workspace 2 && swaymsg exec gtk-launch ~/.local/share/applications/firefox-dev.desktop
sleep 1

swaymsg workspace 3 && swaymsg exec gtk-launch ~/.local/share/applications/firefox-esr.desktop
sleep 1

