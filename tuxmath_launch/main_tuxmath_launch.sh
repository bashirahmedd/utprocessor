#!/usr/bin/env bash
set -e

TARGET_WIDTH=640
TARGET_HEIGHT=480

echo "=== Checking Display Server Setup ==="

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Session Type: Wayland"

    # Auto-fetch gnome-randr if not present
    if ! command -v gnome-randr &> /dev/null && [ ! -f ./gnome-randr.py ]; then
        echo "Fetching gnome-randr script..."
        wget -q https://raw.githubusercontent.com/fraz0815/gnome-randr/master/gnome-randr.py -O gnome-randr.py
        chmod +x gnome-randr.py
    #     GNOME_RANDR="./gnome-randr.py"
    # else
    #     GNOME_RANDR="gnome-randr"
    fi

    GNOME_RANDR="./gnome-randr.py"

    # Detect current resolution and primary display
    PRIMARY_MONITOR=$($GNOME_RANDR | grep -E "^\s*[A-Za-z0-9-]+ \*" | awk '{print $1}')
    CURRENT_RES=$($GNOME_RANDR | grep -A 20 "$PRIMARY_MONITOR" | grep "\*" | head -n 1 | awk '{print $1}')

    echo "Primary Monitor: $PRIMARY_MONITOR"
    echo "Current Resolution: $CURRENT_RES"
    echo "-----------------------------------"
    echo "Changing resolution to ${TARGET_WIDTH}x${TARGET_HEIGHT}..."

    # Apply the new resolution
    $GNOME_RANDR --output "$PRIMARY_MONITOR" --mode "${TARGET_WIDTH}x${TARGET_HEIGHT}"

elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "Session Type: X11"

    PRIMARY_MONITOR=$(xrandr --current | grep " connected" | awk '{print $1}')
    CURRENT_RES=$(xrandr --current | grep -A 1 "$PRIMARY_MONITOR connected" | tail -n 1 | awk '{print $1}')

    echo "Primary Monitor: $PRIMARY_MONITOR"
    echo "Current Resolution: $CURRENT_RES"
    echo "-----------------------------------"
    echo "Changing resolution to ${TARGET_WIDTH}x${TARGET_HEIGHT}..."

    MODE_NAME="${TARGET_WIDTH}x${TARGET_HEIGHT}_60.00"
    MODELINE=$(cvt $TARGET_WIDTH $TARGET_HEIGHT 60 | grep "Modeline" | cut -d' ' -f2-)

    if ! xrandr | grep -q "$TARGET_WIDTH"x"$TARGET_HEIGHT"; then
        xrandr --newmode $MODELINE
        xrandr --addmode "$PRIMARY_MONITOR" "$MODE_NAME"
        xrandr --output "$PRIMARY_MONITOR" --mode "$MODE_NAME"
    else
        xrandr --output "$PRIMARY_MONITOR" --mode "${TARGET_WIDTH}x${TARGET_HEIGHT}"
    fi
else
    echo "Error: Unknown session type."
    exit 1
fi

echo "Resolution update finished!"