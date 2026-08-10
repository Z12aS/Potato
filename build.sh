#!/usr/bin/env bash

LOCK_FILE="/tmp/xdotool_script.pid"

# ==============================================================================
# FUNCTIONS FOR XDOTOOL EVENTS
# ==============================================================================

key_down() {
    xdotool keydown "$1"
}

key_up() {
    xdotool keyup "$1"
}
key_press() {
    local key="$1"
    local dur="$2"
    xdotool keydown "$1"
    sleep "$dur"
    xdotool keyup "$1"
}

click() {
    xdotool mousedown 3
    sleep 0.05
    xdotool mouseup 3
}

move_mouse() {
    xdotool mousemove_relative -- "$1" "$2"
}

release_all_inputs() {
    xdotool mouseup 1 2>/dev/null
    xdotool mouseup 2 2>/dev/null
    xdotool keyup Shift_L 2>/dev/null
}

# ==============================================================================
# WORKFLOW SEQUENCE
# ==============================================================================

run_workflow() {
        key_down "Shift_L"

        for i in {1..27}; do
            # Press space
            key_down "space"

            # Wait 100ms
            sleep 0.1
            key_up "space"
            sleep 0.1
            # Click twice with 200ms intervals
            click
            sleep 0.16
            click
            sleep 0.3
        done

        key_down "space"
        # Wait 100ms
        sleep 0.1
        key_up "space"
        sleep 0.1
        # Click twice with 200ms intervals
        click
        sleep 0.2

        key_press "s" 0.7
        # Wait 200ms more then repeat
        sleep 0.2
        key_up "Shift_L"
        sleep 0.2
        move_mouse 0 -31
        sleep 0.2
        for i in {1..55}; do
            click
            sleep 0.25
        done
        move_mouse 0 31
}

# ==============================================================================
# TOGGLE / EMERGENCY STOP LOGIC
# ==============================================================================

if [ -f "$LOCK_FILE" ]; then
    TARGET_PID=$(cat "$LOCK_FILE")
    rm -f "$LOCK_FILE"

    kill -9 "$TARGET_PID" 2>/dev/null
    release_all_inputs

    echo "Stopped."
    exit 0
fi

echo $$ > "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"; release_all_inputs; exit 0' INT TERM EXIT

echo "Running... Press hotkey again to toggle off."
run_workflow
