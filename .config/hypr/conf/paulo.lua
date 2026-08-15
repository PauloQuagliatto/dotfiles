local HYPRSCRIPTS = "~/.config/hypr/scripts"

-- SwayNC
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0.5 })

-- Pavucontrol
hl.window_rule({
    name   = "pavucontrol",
    match  = { class = "(.*org.pulseaudio.pavucontrol.*)" },
    float  = true,
    center = true,
    pin    = true,
    size   = { 700, 600 },
})

-- Guitarix
hl.window_rule({
    name  = "guitarix",
    match = { class = "(.*guitarix*)" },
    float = false,
})

-- Waypaper
hl.window_rule({
    name   = "waypaper",
    match  = { class = "(.*waypaper.*)" },
    float  = true,
    center = true,
    pin    = true,
    size   = { 900, 700 },
})

-- Newelle
hl.window_rule({
    name   = "newelle",
    match  = { class = "(io.github.qwersyk.Newelle)" },
    float  = true,
    center = true,
    pin    = true,
    size   = { 1000, 700 },
})

-- Blueman Manager
hl.window_rule({
    name   = "blueman-manager",
    match  = { class = "(blueman-manager)" },
    float  = true,
    center = true,
    size   = { 800, 600 },
})

-- nwg-look
hl.window_rule({
    name   = "nwg-look",
    match  = { class = "(nwg-look)" },
    float  = true,
    center = true,
    size   = { 700, 600 },
})

-- nwg-displays
hl.window_rule({
    name   = "nwg-displays",
    match  = { class = "(nwg-displays)" },
    float  = true,
    center = true,
    size   = { 900, 600 },
})

-- System Mission Center
hl.window_rule({
    name   = "missioncenter",
    match  = { class = "(io.missioncenter.MissionCenter)" },
    float  = true,
    center = true,
    pin    = true,
    size   = { 900, 600 },
})

-- Gnome Calculator
hl.window_rule({
    name   = "gnome-calculator",
    match  = { class = "(org.gnome.Calculator)" },
    float  = true,
    center = true,
    size   = { 700, 600 },
})

-- Hyprland Share Picker
hl.window_rule({
    name   = "hyprland-share-picker",
    match  = { class = "(hyprland-share-picker)" },
    float  = true,
    pin    = true,
    center = true,
    size   = { 600, 400 },
})

-- nm-connection-editor
hl.window_rule({
    name   = "nm-connection-editor",
    match  = { class = "(nm-connection-editor)" },
    float  = true,
    center = true,
    size   = { 800, 700 },
})

-- Picture-in-Picture
hl.window_rule({
    name   = "Picture-in-Picture",
    match  = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float  = true,
    pin    = true,
    center = true,
})

-- Flameshot
hl.window_rule({
    name             = "flameshot-multi-display-fix",
    match            = { class = "flameshot" },
    animation        = "fade",
    rounding         = 0,
    border_size      = 0,
    fullscreen_state = "0 0",
    float            = true,
    pin              = true,
    monitor          = "DP-3",
    move             = { 0, 0 },
    size             = { "monitor_w*2", "monitor_h" },
})

-- Float and center file pickers
-- hl.window_rule({
--     name   = "xdg-file-picker",
--     match  = { class = "xdg-desktop-portal-gtk", title = "^(Open.*Files?|Save.*Files?|All Files|Save)" },
--     float  = true,
-- })
-- hl.window_rule({
--     name   = "xdg-file-picker-center",
--     match  = { class = "xdg-desktop-portal-gtk", title = "^(Open.*Files?|Save.*Files?|All Files|Save)" },
--     center = true,
-- })

-- XDG Desktop Portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GDK
hl.env("GDK_SCALE", "1")

-- Toolkit Backend
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Set the cursor size for xcursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Ozone
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-- SDL version
hl.env("SDL_VIDEODRIVER", "wayland")

-- Wayland display
hl.env("WAYLAND_DISPLAY", "wayland-0")

-- Start hyprpaper
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
end)
