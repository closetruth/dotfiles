#!/bin/bash

init_params() {
  # 设置默认倒计时初始值（单位：秒）
  DEFAULT_COUNTDOWN=3600
  ALERT_TIME=600   # 10 分钟提醒
  LOCK_TIME=300     # 300 秒提醒
  MIN_SWAYLOCK_DURATION=600
  WORKSPACE_LOCK_DURATION=300


  if [ ! -f "$STATUS_FILE" ]; then
    echo -e "\n\n" > $STATUS_FILE
    sed -i "1c$DEFAULT_COUNTDOWN" $STATUS_FILE
    sed -i "2c$MIN_SWAYLOCK_DURATION" $STATUS_FILE
    sed -i "3c$WORKSPACE_LOCK_DURATION" $STATUS_FILE
    chmod 666 $STATUS_FILE
  fi

  # 读取旧的倒计时状态（如果有），覆盖默认值
  if [ -f "$STATUS_FILE" ]; then
    local countdown_number="$(sed -n '1p' $STATUS_FILE)"
    local min_swaylock_number="$(sed -n '2p' $STATUS_FILE)"
    local workspace_lock_number="$(sed -n '3p' $STATUS_FILE)"
    if [ "$countdown_number" -gt 0 ]; then
      DEFAULT_COUNTDOWN=$countdown_number
    elif [ "$min_swaylock_number" -gt 0 ]; then
      MIN_SWAYLOCK_DURATION=$min_swaylock_number
    elif [ "$workspace_lock_number" -gt 0 ]; then
      WORKSPACE_LOCK_DURATION=$workspace_lock_number
    else
      sed -i "1c$DEFAULT_COUNTDOWN" $STATUS_FILE
      sed -i "2c$MIN_SWAYLOCK_DURATION" $STATUS_FILE
      sed -i "3c$WORKSPACE_LOCK_DURATION" $STATUS_FILE
    fi
  fi
}

init_fs() {
    MAIN_LOCKFILE="/tmp/lock-screen-countdown/$(whoami)_lock_screen_countdown.lock"
    STATUS_FILE="/tmp/lock-screen-countdown/lock_screen_countdown_status"
    WHO_WRITE_STATUS_FILE="/tmp/lock-screen-countdown/who_write_status_file"

    # 先检查再创建（显式逻辑）
    if [ ! -d "/tmp/lock-screen-countdown" ]; then
        mkdir -p "/tmp/lock-screen-countdown"
        chmod 777 /tmp/lock-screen-countdown
    fi
    

    # 终止已有的倒计时进程
    if [ -f "$MAIN_LOCKFILE" ]; then
        local OLD_PID
        OLD_PID=$(cat "$MAIN_LOCKFILE")
        if ps -p $OLD_PID > /dev/null 2>&1; then
          echo "检测到旧进程 $OLD_PID，发送终止信号..."
          kill -SIGTERM $OLD_PID
          sleep 1  # 等待旧进程退出
        fi
        rm -f "$MAIN_LOCKFILE"
    fi

    # 记录当前进程 ID
    echo $$ > "$MAIN_LOCKFILE"
}

global_cleanup_on_exit() {
    # 定义退出时的清理函数
    cleanup() {
        rm -f "$MAIN_LOCKFILE"
        if [ "$(cat $WHO_WRITE_STATUS_FILE)" == "$(whoami)" ]; then
            rm -f "$WHO_WRITE_STATUS_FILE"
        fi
        echo "脚本退出，清除倒计时输出"
        exit 0
    }

    # 捕获 SIGINT 和 SIGTERM 信号，调用清理函数
    trap cleanup SIGINT SIGTERM
}

who_write_update() {
    # 记录写入状态文件的用户
    if [ ! -f "$WHO_WRITE_STATUS_FILE" ]; then
        echo "$(whoami)" > "$WHO_WRITE_STATUS_FILE"
    fi
}

status() {
    # 判断是否又脚本对/tmp/lock-screen-countdown/lock_screen_countdown_status 进行写操作
    local countdown_number="$(sed -n '1p' $STATUS_FILE)"
    local min_swaylock_number="$(sed -n '2p' $STATUS_FILE)"
    local workspace_lock_number="$(sed -n '3p' $STATUS_FILE)"

    if [ ! -f "$WHO_WRITE_STATUS_FILE" ] || [ "$(cat $WHO_WRITE_STATUS_FILE)" = "$(whoami)" ]; then
        if [ "$countdown_number" -gt 0 ]; then
            echo "countdown";
        elif [ "$min_swaylock_number" -gt 0 ]; then
            echo "min_swaylock";
        elif [ "$workspace_lock_number" -gt 0 ]; then
            echo "workspace_lock";
        fi
    else
        if [ "$countdown_number" -gt 0 ]; then
            echo "countdown_run";
        elif [ "$min_swaylock_number" -gt 0 ]; then
            echo "min_swaylock_run";
        elif [ "$workspace_lock_number" -gt 0 ]; then
            echo "workspace_lock_run";
        fi
    fi
}

print_countdown() {
    # 倒计时一次
    local countdown=$(sed -n '1p' "$STATUS_FILE")
    local minutes=$((countdown / 60))
    local seconds=$((countdown % 60))
    echo "$minutes:$seconds"

    # 10 分钟提醒
    if [ $countdown -eq $ALERT_TIME ]; then
      notify-send "锁屏提醒" "还有 10 分钟将自动锁屏，请注意保存工作！"
    fi

    # 5 分钟提醒
    if [ $countdown -eq $LOCK_TIME ]; then
      notify-send "锁屏提醒" "还有5分钟锁屏！请做好准备！"
    fi

    countdown=$((countdown - 1))
    sed -i "1c$countdown" $STATUS_FILE
}

min_swaylock() {

    SWAYLOCK_LOCKFILE="/tmp/lock-screen-countdown/$(whoami)_min_swaylock.lock"

    # 捕获退出信号（Ctrl+C/SIGTERM）
    trap 'cleanup' INT TERM EXIT

    # 清理函数
    cleanup() {
        rm -rf $SWAYLOCK_LOCKFILE
        pkill -P $$ 2>/dev/null  # 杀死所有子进程
        global_cleanup_on_exit
        exit 0
    }


    # 后台倒计时更新（带锁检查）
    (
        # 如果锁文件存在，说明已经在运行，直接退出
        if [ -f "$SWAYLOCK_LOCKFILE" ]; then
            exit 0
        fi

        # 创建锁文件
        touch "$SWAYLOCK_LOCKFILE"

        # 倒计时逻辑
        while [ -f "$STATUS_FILE" ]; do
            countdown=$(sed -n '2p' "$STATUS_FILE")
            [ "$countdown" -le 0 ] && break
            sleep 1
            sed -i "2c$((countdown - 1))" "$STATUS_FILE"
        done

        # 删除锁文件
        rm -f "$SWAYLOCK_LOCKFILE"
    ) &

    local countdown=$(sed -n '2p' "$STATUS_FILE")
    echo "剩余锁定时间: $countdown 秒"
    
    # 启动锁屏
    if [ "$countdown" -ne 0 ]; then
        swaylock -i ~/.config/waybar/lock-screen.jpg
        echo "检测到解锁时间不足 10 分钟（还有 ${countdown} 秒），立即重新锁屏..."
        notify-send "检测到解锁时间不足 10 分钟（还有 ${countdown} 秒），立即重新锁屏..."
    else 
        echo "锁定时间已超过 10 分钟，允许解锁。"
        cleanup
    fi
}

workspace_lock() {
    local countdown=$(sed -n '3p' $STATUS_FILE)
    if [ $countdown -ne 0 ]; then
        swaymsg workspace 1
    fi
    countdown=$((countdown - 1))
    sed -i "3c$countdown" $STATUS_FILE
}

alt_print_countdown() {
    local countdown=$(sed -n '1p' $STATUS_FILE)
    # 倒计时一次
    local minutes=$((countdown / 60))
    local seconds=$((countdown % 60))
    echo "$minutes:$seconds"

    # 10 分钟提醒
    if [ "$countdown" -eq $ALERT_TIME ]; then
        notify-send "锁屏提醒" "还有 10 分钟将自动锁屏，请注意保存工作！"
    fi

    # 5 分钟提醒
    if [ "$countdown" -eq $LOCK_TIME ]; then
        notify-send "锁屏提醒" "还有5分钟锁屏！请做好准备！"
    fi
}

alt_min_swaylock() {

    local countdown=$(sed -n "2p" $STATUS_FILE)

    if [ "$countdown" -gt 0 ]; then
        # 调用 swaylock，等待用户解锁
        swaylock -i ~/.config/waybar/lock-screen.jpg
        echo "检测到解锁时间不足 10 分钟（还有 ${countdown} 秒），立即重新锁屏..."
        notify-send "检测到解锁时间不足 10 分钟（还有 ${countdown} 秒），立即重新锁屏..."
        # 循环继续，重新调用 swaylock
    else
        echo "锁定时间已超过 10 分钟，允许解锁。"
    fi
}

alt_workspace_lock() {
    local countdown=$(sed -n "3p" $STATUS_FILE)
    
    if [ "$countdown" -gt 0 ]; then
        swaymsg workspace 1
    fi
}


# 创建文件
init_fs

# 加载参数,写入参数到文件
init_params

global_cleanup_on_exit

# 主循环：每次倒计时结束后，执行锁屏操作，然后重新启动倒计时
while true; do
    who_write_update
    if [ "$(status)" = "countdown" ]; then
        print_countdown 
    elif [ "$(status)" = "min_swaylock" ]; then
        min_swaylock
    elif [ "$(status)" = "workspace_lock" ]; then
        workspace_lock
    elif [ "$(status)" = "countdown_run" ]; then
        alt_print_countdown
    elif [ "$(status)" = "min_swaylock_run" ]; then
        alt_min_swaylock
    elif [ "$(status)" = "workspace_lock_run" ]; then
        alt_workspace_lock
    else 
        init_params
    fi
    sleep 1
done
