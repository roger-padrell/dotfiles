#!/bin/bash

options="Shutdown\nReboot\nLog out\nSleep"

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
        hyprlock && systemctl suspend
        ;;
esac
