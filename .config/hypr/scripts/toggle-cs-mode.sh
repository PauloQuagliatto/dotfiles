#!/usr/bin/env bash
#                                      __   
#   ___ ____ ___ _  ___ __ _  ___  ___/ /__ 
#  / _ `/ _ `/  ' \/ -_)  ' \/ _ \/ _  / -_)
#  \_, /\_,_/_/_/_/\__/_/_/_/\___/\_,_/\__/ 
# /___/                                     
# 


paulo_cache_folder="$HOME/.cache/paulo/hyprland-dotfiles"
cs_monitor="$HOME/.config/hypr/conf/monitors/cs.conf"
default_monitor="$HOME/.config/hypr/conf/monitors/default.conf"
monitor_conf="$HOME/.config/hypr/conf/monitor.conf"
flag_file="$HOME/.config/paulo/settings/cs-enabled"

# Ensure required directories exist
mkdir -p "$paulo_cache_folder"
mkdir -p "$(dirname "$flag_file")"
mkdir -p "$(dirname "$monitor_conf")"

# Toggle logic
if [ -f "$flag_file" ]; then
    # cs mode is enabled; restore previous config
    if [ -f "$paulo_cache_folder/last_monitor.conf" ]; then
        cat "$paulo_cache_folder/last_monitor.conf" > "$monitor_conf"
        rm "$paulo_cache_folder/last_monitor.conf"
    else
        # Fallback: default monitor setup if no backup
        echo "source=$default_monitor" > "$monitor_conf"
    fi
    rm "$flag_file"
else
    # cs mode is disabled; switch to cs monitor
    if [ -f "$cs_monitor" ]; then
        # Backup current monitor config
        cat "$monitor_conf" > "$paulo_cache_folder/last_monitor.conf"
        # Source the cs monitor config
        echo "source=$cs_monitor" > "$monitor_conf"
    fi
    touch "$flag_file"
fi

# Reload Hyprland config to apply changes
hyprctl reload 2>/dev/null || echo "Failed to reload Hyprland config. Is Hyprland running?"
