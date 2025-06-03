#!/bin/bash

# Power menu script for Waybar
# Requires: wofi or rofi

# Check if wofi is installed, otherwise use rofi
if command -v wofi &>/dev/null; then
  MENU="wofi -d -p 'Power Menu' -W 200 -H 260"
else
  MENU="rofi -dmenu -p 'Power Menu' -theme ~/.config/rofi/powermenu.rasi"
fi

# Options
options=("󰤄 Lock" "󰗽 Logout" "󰑐 Reboot" "󰐥 Shutdown" "󰕾 Cancel")

# Show menu and get user choice
choice=$(printf '%s\n' "${options[@]}" | $MENU | awk '{print $2}')

# Execute based on choice
case $choice in
"Lock")
  swaylock -f -c 000000
  ;;
"Logout")
  hyprctl dispatch exit
  ;;
"Reboot")
  systemctl reboot
  ;;
"Shutdown")
  systemctl poweroff
  ;;
*)
  exit 0
  ;;
esac
