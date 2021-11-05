#!/usr/bin/env bash

if [[ $(ps -ef | grep -c 'polybar --reload tray') -ne 1 ]]; then
    pkill -f 'polybar --reload tray'
else
    polybar --reload tray -c ~/.config/polybar/config.ini &
fi
