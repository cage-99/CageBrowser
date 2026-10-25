#!/usr/bin/env bash
export DISPLAY=${DISPLAY:-:0}
export XDG_SESSION_TYPE=x11
export XDG_SESSION_DESKTOP=x11
export WAYLAND_DISPLAY=
export GDK_BACKEND=x11
export QT_QPA_PLATFORM=xcb
export SDL_VIDEODRIVER=x11
export OZONE_PLATFORM=x11
export ELECTRON_OZONE_PLATFORM_HINT=x11

pkill -9 -f godot 2>/dev/null
pkill -9 -f gdcef_helper 2>/dev/null
pkill -9 -f libcef 2>/dev/null
sleep 2

cd "$(dirname "$0")"
exec godot --path . --rendering-driver opengl3 "$@"
