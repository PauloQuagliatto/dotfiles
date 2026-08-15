-- -----------------------------------------------------
-- Key bindings
-- name: "Default"
-- -----------------------------------------------------

-- SUPER KEY
local mainMod       = "SUPER"
local fileManager   = "nautilus"
local steam         = "steam"
local SETTINGS      = "~/.config/paulo/settings"
local browser       = SETTINGS .. "/browser.sh"
local HYPRSCRIPTS   = "~/.config/hypr/scripts"
local terminal      = SETTINGS .. "/terminal.sh"
local launcher      = HYPRSCRIPTS .. "/launcher.sh"
local audio_control = HYPRSCRIPTS .. "/pavucontrol.sh"

-- Apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(steam))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(audio_control))

-- Window
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())    -- dwindle
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }))  -- Swap tiled window left
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" })) -- Swap tiled window right
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }))     -- Swap tiled window up
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" })) -- Swap tiled window down
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())

-- Actions
-- hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggle-cs-mode.sh"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
-- removed: duplicate bind referencing the undefined $cs variable (was $mainMod SHIFT, S, exec, $cs)

-- Workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Fn keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10%"))      -- Increase brightness by 10%
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))    -- Reduce brightness by 10%
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })  -- Increase volume by 5% (max 100% limit also added hold to raise volume)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })       -- Reduce volume by 5% (min 0% limit also added hold to lower volume)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))  -- Toggle mute
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))              -- Audio play pause
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))                  -- Audio pause
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))                    -- Audio next
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))                -- Audio previous
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle")) -- Toggle microphone
hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh")) -- Open calculator
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"))                        -- Open screenlock
hl.bind("XF86Tools", hl.dsp.exec_cmd("flatpak run com.ml4w.settings"))         -- Open ML4W Dotfiles Settings app

hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))
