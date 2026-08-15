hl.monitor({
    output   = "DP-2",
    mode     = "1024x768@120",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output    = "HDMI-A-1",
    mode      = "1440x900@74.98",
    position  = "1024x0",
    scale     = 1,
    transform = 1,
})

hl.exec_cmd("xrandr --output DP-2 --primary")
