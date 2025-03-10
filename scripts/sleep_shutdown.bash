#!/bin/bash

start=$((13*60 + 30))  # 13:30 转换为分钟
end=$((22*60 + 0))         # 22:00 转换为分钟

while true; do
    current_hour=$(date +%H)
    current_minute=$(date +%M)
    current_total=$((10#$current_hour * 60 + 10#$current_minute))

    if [ $current_total -ge $start ] && [ $current_total -le $end ]; then
        sudo shutdown -h now
    fi
    sleep 60
done


