--    ___       __           __           __
--   / _ |__ __/ /____  ___ / /____ _____/ /_
--  / __ / // / __/ _ \(_-</ __/ _ `/ __/ __/
-- /_/ |_\_,_/\__/\___/___/\__/\_,_/_/  \__/
--

hl.on("hyprland.start", function()
    -- Start Listeners
    hl.exec_cmd("~/.config/paulo/listeners.sh --startall")

    -- Start Polkit
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Load Wallpaper
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper-restore.sh")

    -- Load Notification Daemon
    hl.exec_cmd("swaync")

    -- Start XDG
    hl.exec_cmd("~/.config/hypr/scripts/xdg.sh")

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Using hypridle to start hyprlock
    hl.exec_cmd("hypridle")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
end)
