#!/bin/bash

# 设置倒计时的初始值（30分钟 = 1800秒）
COUNTDOWN=1800
ALERT_TIME=600  # 10分钟
LOCK_TIME=10    # 锁屏前的最后10秒提醒
LOCKFILE="/tmp/countdown.lock"

# 终止已有的倒计时进程
if [ -f "$LOCKFILE" ]; then
    OLD_PID=$(cat "$LOCKFILE")
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "检测到旧进程 $OLD_PID，正在终止..."
        kill $OLD_PID
    fi
    rm -f "$LOCKFILE"
fi

# 记录当前进程 ID
echo $$ > "$LOCKFILE"

# 定义一个退出函数，用于清理资源
exit_gracefully() {
    rm -f "$LOCKFILE"
    echo "脚本退出，清除倒计时输出"
    exit 0
}

# 捕获终止信号（如 Ctrl+C）
trap exit_gracefully SIGINT SIGTERM

# 进入倒计时并输出
while [ $COUNTDOWN -gt 0 ]; do
    MINUTES=$((COUNTDOWN / 60))
    SECONDS=$((COUNTDOWN % 60))

    echo "倒计时: $MINUTES 分 $SECONDS 秒"

    sleep 1
    COUNTDOWN=$((COUNTDOWN - 1))
done

# 清理锁文件
rm -f "$LOCKFILE"
