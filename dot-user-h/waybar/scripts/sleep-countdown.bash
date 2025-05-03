#!/bin/bash

lockfile="/tmp/sleep_countdown.lock"

# 如果锁文件存在，则尝试杀死之前的进程
if [[ -e "$lockfile" ]]; then
    pid=$(cat "$lockfile")
    if ps -p "$pid" &>/dev/null; then
        echo "检测到已有实例 (PID: $pid)，正在终止..."
        kill "$pid"
        sleep 1  # 等待进程结束
    fi
fi

# 记录当前进程 ID
echo $$ > "$lockfile"

# 退出时删除锁文件
trap 'rm -f "$lockfile"' EXIT

# 获取当前时间的秒数
current_time=$(date +%s)

# 获取今天 13:30 的秒数
target_time=$(date -d "13:30" +%s)

# 如果已经过了 13:30，则计算明天 13:30
if [[ $current_time -ge $target_time ]]; then
    target_time=$(date -d "tomorrow 13:30" +%s)  # 修正为13:30保持一致性
fi

# 计算剩余时间
remaining_seconds=$((target_time - current_time))

# 添加5分钟提醒标志变量
notified=false

while [[ $remaining_seconds -gt 0 ]]; do
    hours=$((remaining_seconds / 3600))
    minutes=$(((remaining_seconds % 3600) / 60))
    
    # 添加5分钟提醒逻辑
    if [[ $remaining_seconds -le 300 ]] && [[ $notified == false ]]; then
        notify-send "提醒" "距离目标时间还剩5分钟！"
        notified=true
    fi
    
    echo "$hours:$minutes|"
    sleep 60  # 每分钟更新一次
    remaining_seconds=$((remaining_seconds - 60))
done

echo -e "\n时间到！"
notify-send "提醒" "时间已到！"
