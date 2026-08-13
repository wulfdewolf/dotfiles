---@module 'hl'

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.config({
    input = {
        kb_layout = "gb",
        follow_mouse = 0,
    },
})

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
    },
})

hl.config({
    animations = {
        enabled = false,
    },
})

hl.config({
    decoration = {
        rounding = 0,
    },
})


-- Applications
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("hyprlock"))

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())

-- Audio
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%")
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%")
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")
)

-- Brightness
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +5%")
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%-")
)

-- Boot shortcuts
hl.bind("SUPER + B", hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("slack"))

-- Focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

-- Movement
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Workspaces
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Screenshots
hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        'grim -g "$(slurp)" ~/Downloads/screenshot_$(date +%F_%T).png'
    )
)

hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        'grim ~/Downloads/screenshot_$(date +%F_%T).png'
    )
)

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
end)
