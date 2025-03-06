#!/bin/bash

countdown() {
    # 设置默认倒计时初始值（单位：秒）
    local DEFAULT_COUNTDOWN=3600
    local ALERT_TIME=600   # 10 分钟提醒
    local LOCK_TIME=60     # 60 秒提醒

    local LOCKFILE="/tmp/lock_screen_countdown.lock"
    local STATUS_FILE="/tmp/lock_screen_countdown_status"

    # 读取旧的倒计时状态（如果有），覆盖默认值
    if [ -f "$STATUS_FILE" ]; then
        local OLD_COUNTDOWN
        OLD_COUNTDOWN=$(cat "$STATUS_FILE")
        if [[ "$OLD_COUNTDOWN" =~ ^[0-9]+$ ]]; then
            DEFAULT_COUNTDOWN=$OLD_COUNTDOWN
        fi
    fi

    local COUNTDOWN=$DEFAULT_COUNTDOWN

    # 终止已有的倒计时进程
    if [ -f "$LOCKFILE" ]; then
        local OLD_PID
        OLD_PID=$(cat "$LOCKFILE")
        if ps -p $OLD_PID > /dev/null 2>&1; then
            echo "检测到旧进程 $OLD_PID，发送终止信号..."
            kill -SIGTERM $OLD_PID
            sleep 1  # 等待旧进程退出
        fi
        rm -f "$LOCKFILE"
    fi

    # 记录当前进程 ID
    echo $$ > "$LOCKFILE"

    # 定义退出时的清理函数
    exit_gracefully() {
        echo $COUNTDOWN > "$STATUS_FILE"  # 保存当前倒计时值
        rm -f "$LOCKFILE"
        echo "脚本退出，清除倒计时输出"
        exit 0
    }

    # 捕获 SIGINT 和 SIGTERM 信号，调用清理函数
    trap exit_gracefully SIGINT SIGTERM

    # 进入倒计时循环
    while [ $COUNTDOWN -gt 0 ]; do
        echo $COUNTDOWN > "$STATUS_FILE"  # 实时更新状态文件

        local MINUTES=$((COUNTDOWN / 60))
        local SECONDS=$((COUNTDOWN % 60))
        echo "$MINUTES:$SECONDS"

        # 10 分钟提醒
        if [ $COUNTDOWN -eq $ALERT_TIME ]; then
            notify-send "锁屏提醒" "还有 10 分钟将自动锁屏，请注意保存工作！"
        fi

        # 1 分钟提醒
        if [ $COUNTDOWN -eq $LOCK_TIME ]; then
            notify-send "锁屏提醒" "还有1分钟锁屏！请做好准备！"
        fi

        sleep 1
        COUNTDOWN=$((COUNTDOWN - 1))
    done
    # 清理状态文件
    rm -f "$LOCKFILE" "$STATUS_FILE"
}

# 主循环：每次倒计时结束后，执行锁屏操作，然后重新启动倒计时
while true; do
    countdown

    # 倒计时结束，自动锁屏
    notify-send "锁屏中" "时间已到，正在锁屏..."

    # 切换到笔记工作区
    swaymsg workspace 1

    # 锁屏
    ~/.config/waybar/scripts/lib_min_swaylock.bash    
done
