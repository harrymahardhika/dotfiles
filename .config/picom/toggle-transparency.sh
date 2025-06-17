#!/bin/bash
if [ -f /tmp/picom_transparent ]; then
    rm /tmp/picom_transparent
    killall picom
    sleep 1
    picom --config $HOME/.config/picom/picom-solid.conf &
else
    touch /tmp/picom_transparent
    killall picom
    sleep 1
    picom --config $HOME/.config/picom/picom.conf &
fi

