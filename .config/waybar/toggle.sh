#!/usr/bin/env bash
#  _____                 _       __        __          _
# |_   _|__   __ _  __ _| | ___  \ \      / /_ _ _   _| |__   __ _ _ __
#   | |/ _ \ / _` |/ _` | |/ _ \  \ \ /\ / / _` | | | | '_ \ / _` | '__|
#   | | (_) | (_| | (_| | |  __/   \ V  V / (_| | |_| | |_) | (_| | |
#   |_|\___/ \__, |\__, |_|\___|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|
#            |___/ |___/                         |___/
#

if [ -f $HOME/.config/paulo/settings/waybar-disabled ]; then
    sh $HOME/.config/waybar/launch.sh
    rm $HOME/.config/paulo/settings/waybar-disabled
else
    killall waybar || true
    pkill waybar || true
    sleep 0.5
    touch $HOME/.config/paulo/settings/waybar-disabled
fi
$HOME/.config/waybar/launch.sh &
