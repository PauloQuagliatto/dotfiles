#!/usr/bin/env bash
#   ____ _
#  / ___| | ___  __ _ _ __  _   _ _ __
# | |   | |/ _ \/ _` | '_ \| | | | '_ \
# | |___| |  __/ (_| | | | | |_| | |_) |
#  \____|_|\___|\__,_|_| |_|\__,_| .__/
#                                |_|
#

# Remove gamemode flag
if [ -f ~/.config/paulo/settings/cs-enabled ]; then
    rm ~/.config/paulo/settings/cs-enabled
    echo ":: ~/.config/paulo/settings/cs-enabled removed"
fi

if [ ! -f ~/.config/paulo/settings/waybar-disabled ]; then
    touch ~/.config/paulo/settings/waybar-disabled
    echo ":: ~/.config/paulo/settings/waybar-disabled created"
fi
