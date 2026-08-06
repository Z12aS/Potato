#!/usr/bin/env bash

PIDFILE="/tmp/autoclicker.pid"

if [ -f "$PIDFILE" ]; then
    # Script is currently running -> stop it
    kill "$(cat "$PIDFILE")"
    rm -f "$PIDFILE"
    exit 0
else
    # Script is not running -> start the loop in the background
    (
        while true; do
            xdotool mousemove_relative -- 1 0
            sleep 0.01
            xdotool mousemove_relative -- -1 0
            sleep 0.1
            xdotool mousedown 1
            sleep 0.05
            xdotool mouseup 1
            sleep 10
        done
    ) &

    # Save the background loop PID
    echo $! > "$PIDFILE"
fi
