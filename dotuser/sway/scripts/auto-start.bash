#!/bin/bash
swaymsg workspace 1 && swaymsg exec 'xfce4-terminal -x notes.bash'
sleep 1

swaymsg workspace 2 && swaymsg exec firefox-dev
sleep 1

swaymsg workspace 3 && swaymsg exec firefox-esr
sleep 1

