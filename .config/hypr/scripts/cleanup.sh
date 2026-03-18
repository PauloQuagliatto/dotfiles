#!/usr/bin/env bash
#   ____ _
#  / ___| | ___  __ _ _ __  _   _ _ __
# | |   | |/ _ \/ _` | '_ \| | | | '_ \
# | |___| |  __/ (_| | | | | |_| | |_) |
#  \____|_|\___|\__,_|_| |_|\__,_| .__/
#                                |_|
#

# Remove gamemode flag
if [ -f ~/.cache/cs ]; then
    rm ~/.cache/cs
    echo ":: ~/.cache/cs removed"
fi

if [ -f ~/.config/paulo/settings/waybar-disabled ]; then
    rm ~/.config/paulo/settings/waybar-disabled
    echo ":: ~/.config/paulo/settings/waybar-disabled removed"
fi
