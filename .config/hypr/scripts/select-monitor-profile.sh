#!/usr/bin/env bash
#    __  ___                 ____  _          __
#   /  |/  /__  ____  __ __/ __ \(_)______ _/ /
#  / /|_/ / _ \/ __ \/ // / / / / / __/ _ `/ / 
# /_/  /_/\___/_//_/\_,_/_/ /_/_/_/ \_,_/_/_/  
#

PROFILE_FILE="$HOME/.cache/paulo/hyprland-dotfiles/monitor-profile"
MONITOR_CONF="$HOME/.config/hypr/conf/monitor.lua"
CACHE_DIR="$HOME/.cache/paulo/hyprland-dotfiles"

PROFILES=(default cs gambiarra notebook)
DEFAULT_PROFILE="default"

mkdir -p "$CACHE_DIR"

get_current_profile() {
    if [ -f "$PROFILE_FILE" ]; then
        local stored
        stored=$(cat "$PROFILE_FILE")
        for p in "${PROFILES[@]}"; do
            if [ "$stored" = "$p" ]; then
                echo "$stored"
                return
            fi
        done
    fi
    echo "$DEFAULT_PROFILE"
}

set_profile() {
    local target="$1"
    local valid=false
    for p in "${PROFILES[@]}"; do
        if [ "$target" = "$p" ]; then
            valid=true
            break
        fi
    done

    if [ "$valid" = false ]; then
        echo "Error: Unknown profile '$target'"
        echo "Available: ${PROFILES[*]}"
        return 1
    fi

    echo "$target" > "$PROFILE_FILE"
    echo "require(\"conf.monitors.$target\")" > "$MONITOR_CONF"
    hyprctl reload 2>/dev/null
    echo "Monitor profile set to: $target"
}

list_profiles() {
    local current
    current=$(get_current_profile)
    for p in "${PROFILES[@]}"; do
        if [ "$p" = "$current" ]; then
            echo "  [*] $p"
        else
            echo "  [ ] $p"
        fi
    done
}

show_menu() {
    local current
    current=$(get_current_profile)

    echo ""
    echo "  Monitor Profiles"
    echo "  ─────────────────"
    local i=1
    for p in "${PROFILES[@]}"; do
        if [ "$p" = "$current" ]; then
            echo "  $i) $p *"
        else
            echo "  $i) $p"
        fi
        ((i++))
    done
    echo ""
    printf "  Select [1-%d]: " "${#PROFILES[@]}"
    read -r choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#PROFILES[@]}" ]; then
        echo "Invalid selection."
        return 1
    fi

    local selected="${PROFILES[$((choice - 1))]}"
    set_profile "$selected"
}

case "${1:-}" in
    set)
        if [ -z "${2:-}" ]; then
            echo "Usage: $0 set <profile>"
            echo "Available: ${PROFILES[*]}"
            exit 1
        fi
        set_profile "$2"
        ;;
    get)
        get_current_profile
        ;;
    list)
        list_profiles
        ;;
    "")
        show_menu
        ;;
    *)
        echo "Usage: $0 [set <profile> | get | list]"
        exit 1
        ;;
esac
