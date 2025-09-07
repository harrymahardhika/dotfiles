#!/usr/bin/env bash

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "Detected X11 session → using GTK portal"
    export XDG_CURRENT_DESKTOP=GNOME
    systemctl --user stop xdg-desktop-portal{,-gtk,-wlr} 2>/dev/null
    systemctl --user start xdg-desktop-portal-gtk
    systemctl --user start xdg-desktop-portal
else
    echo "Detected Wayland session → using WLR portal"
    export XDG_CURRENT_DESKTOP=sway
    systemctl --user stop xdg-desktop-portal{,-gtk,-wlr} 2>/dev/null
    systemctl --user start xdg-desktop-portal-wlr
    systemctl --user start xdg-desktop-portal
fi

