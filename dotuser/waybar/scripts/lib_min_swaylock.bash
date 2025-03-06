#!/bin/bash
# 设置最小锁定时长（单位：秒），这里为 600 秒（10 分钟）
MIN_DURATION=600
start_time=$(date +%s)

while true; do
  # 记录开始时间
  
  # 调用 swaylock，等待用户解锁
  swaylock -c 111111
  
  # 记录解锁时间
  end_time=$(date +%s)
  
  # 计算本次锁定持续时间
  elapsed=$(( end_time - start_time ))
  
  if [ $elapsed -lt $MIN_DURATION ]; then
    echo "检测到解锁时间不足 10 分钟（仅 ${elapsed} 秒），立即重新锁屏..."
    notify-send "检测到解锁时间不足 10 分钟（仅 ${elapsed} 秒），立即重新锁屏..."
    # 这里循环继续，重新调用 swaylock
  else
    echo "锁定时间已超过 10 分钟，允许解锁。"
    break
  fi
done
