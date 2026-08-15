hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@239.96",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output   = "HDMI-A-1",
    disabled = true,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("xrandr --output DP-2 --primary")
end)
