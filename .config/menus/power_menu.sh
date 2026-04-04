#!/bin/bash

options="Shutdown\nReboot\nLog out\nSleep\nScreenshot"

choice=$(echo -e "$options" | walker --dmenu)

case $choice in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    "Log out")
        hyprctl dispatch exit
        ;;
    Sleep)
        lock-suspend.sh
        ;;
    Screenshot)
        hyprshot -m window
        ;;
esac
