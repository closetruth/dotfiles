#!/bin/bash

# 设置默认倒计时初始值
DEFAULT_COUNTDOWN=3600
ALERT_TIME=600   # 10 分钟提醒
LOCK_TIME=60     # 60 秒提醒

LOCKFILE="/tmp/lock_screen_countdown.lock"
STATUS_FILE="/tmp/lock_screen_countdown_status"

# 读取旧的倒计时状态（如果有）
if [ -f "$STATUS_FILE" ]; then
    OLD_COUNTDOWN=$(cat "$STATUS_FILE")
    if [[ "$OLD_COUNTDOWN" =~ ^[0-9]+$ ]]; then
        DEFAULT_COUNTDOWN=$OLD_COUNTDOWN  # 覆盖默认值
    fi
fi

COUNTDOWN=$DEFAULT_COUNTDOWN  # 设置最终倒计时值

# 终止已有的倒计时进程
if [ -f "$LOCKFILE" ]; then
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

# 退出时清理
exit_gracefully() {
    echo $COUNTDOWN > "$STATUS_FILE"  # 退出前保存倒计时
    rm -f "$LOCKFILE"
    echo "脚本退出，清除倒计时输出"
    exit 0
}

trap exit_gracefully SIGINT SIGTERM

# 进入倒计时
while [ $COUNTDOWN -gt 0 ]; do
    echo $COUNTDOWN > "$STATUS_FILE"  # 实时更新状态文件

    MINUTES=$((COUNTDOWN / 60))
    SECONDS=$((COUNTDOWN % 60))
    echo "$MINUTES:$SECONDS"

    # 10 分钟提醒
    if [ $COUNTDOWN -eq $ALERT_TIME ]; then
        notify-send "锁屏提醒" "还有 10 分钟将自动锁屏，请注意保存工作！"
    fi

    # 10 秒提醒
    if [ $COUNTDOWN -eq $LOCK_TIME ]; then
        notify-send "锁屏提醒" "还有1分钟锁屏！请做好准备！"
    fi

    sleep 1
    COUNTDOWN=$((COUNTDOWN - 1))
done

# 倒计时结束，自动锁屏
notify-send "锁屏中" "时间已到，正在锁屏..."
swaylock -c 111111

# 清理文件
rm -f "$LOCKFILE" "$STATUS_FILE"
