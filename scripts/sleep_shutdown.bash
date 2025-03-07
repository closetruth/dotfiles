#!/bin/bash

# 定时关机,用systemd启动

while true; do
    HOUR=$(date +%H)
    if [ "$HOUR" -ge 14 ] && [ "$HOUR" -lt 22 ]; then
        sudo shutdown -h now
    fi
    sleep 60
done

