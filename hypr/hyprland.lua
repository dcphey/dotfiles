----------------
-- AUTOSTARTS --
----------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("uwsm-app -- quickshell")
    hl.exec_cmd("systemctl --user start hyprpaper")
    hl.exec_cmd("systemctl --user start hyprsunset")
    hl.exec_cmd("systemctl --user start hypridle")
    hl.exec_cmd("systemctl --user start wayland-wm-app-daemon")
    -- Clipboard
    hl.exec_cmd("cliphist wipe")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-----------
-- BINDS --
-----------

local mainMod = "SUPER"
local fileExplorer = "dolphin"

-- Exit
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("WIN + F4", hl.dsp.exec_raw("hyprshutdown"))

-- Terminal & app
hl.bind("SHIFT + F10", hl.dsp.exec_raw("uwsm-app -T & disown"))
hl.bind("SHIFT + F11", hl.dsp.exec_raw("uwsm-app -T -- python3 & disown"))
hl.bind(mainMod .. " + E", hl.dsp.exec_raw("uwsm-app -- " .. fileExplorer .. "& disown"))

-- Screen lock
hl.bind(mainMod .. " + L", hl.dsp.exec_raw("loginctl lock-session"))

-- Workspace
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))

hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.move({ workspace = "r-1", follow = false }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ workspace = "r+1", follow = false }))

-- Window
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.float())

hl.bind("F11", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.window.move({ direction = "d" }))

hl.bind("ALT + Tab",         hl.dsp.window.cycle_next())
hl.bind("SHIFT + ALT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Multimedia keys for volume and brightness
hl.bind("XF86AudioRaiseVolume",         hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +1dB"),     { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",         hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -1dB"),     { locked = true, repeating = true })
hl.bind("XF86AudioMute",                hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-source-volume @DEFAULT_SOURCE@ +1dB"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-source-volume @DEFAULT_SOURCE@ -1dB"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioMute",        hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",          hl.dsp.exec_cmd("brightnessctl s 5%+"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",        hl.dsp.exec_cmd("brightnessctl s 5%-"),                           { locked = true, repeating = true })

-- Multimedia key for players
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Quick menu (rofi)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + R", hl.dsp.exec_raw("rofi -show drun -config 'app'"))
hl.bind(mainMod .. " + X", hl.dsp.exec_raw("rofi -show Power -modes 'Power:~/.config/rofi/power.sh'"))

-- Status bar (Quickshell)
hl.bind(mainMod .. " + " .. mainMod .. "_L", hl.dsp.exec_cmd("qs ipc call $(hyprctl activeworkspace -j | jq -r '.monitor') toggleOverlay"), { release = true })
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("qs ipc call $(hyprctl activeworkspace -j | jq -r '.monitor') toggleVisibility"))

-- Screenshot (grim & slurp)
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | wl-copy"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | grim -g - - | wl-copy"))

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r-1" }))

-- Touchpad
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

--------------
-- MONITORS --
--------------

hl.monitor({ output = "eDP-1", mode = "1920x1080@60.2", position = "0x0", scale = 1.25 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x-1080", scale = "auto" })

---------------------------
-- ENVRIONMENT VARIABLES --
---------------------------

-- Electron-based apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG
hl.env("XDG_MENU_PREFIX", "arch-")

-- IME
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")

-- Cursor
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-------------------
-- LOOK AND FEEL --
-------------------

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,

        border_size = 0,
        resize_on_border = true,

        layout = "dwindle"
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            color = "rgba(00000010)"
        },

        blur = {
            enabled = true,
            size = 10,
            passes = 2
        }
    },

    animations = {
        enabled = true
    },

    input = {
        numlock_by_default = true,

        scroll_method = "2fg",

        sensitivity = 0.3,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.6
        }
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,

        vrr = 2
    },

    binds = {
        scroll_event_delay = 0
    },

    xwayland = {
        force_zero_scaling = true
    },

    dwindle = {
        preserve_split = true
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true
    }
})

----------------
-- ANINATIONS --
----------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

------------------
-- WINDOW RULES --
------------------

-- Ignore maximize requirests from apps
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
-- Fix some dragging issues with XWayland
hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
-- Prevent entering idle mode while video is playing
hl.window_rule({ match = { class = ".*", focus = true }, idle_inhibit = "fullscreen" })
-- Remove blurring on floating window
hl.window_rule({ match = { xwayland = true, float = true }, no_blur = true })
-- Compensate missing blur on Intellij
hl.window_rule({ match = { class = "jetbrians-idea-ce" }, opacity = 1.2 })

---------------------
-- WORKSPACE RULES --
---------------------

-- Universal "gaps_out" rule for Quickshell status bar adjustment
hl.workspace_rule({ workspace = "", gaps_out = { top = 0, left = 6, right = 6, bottom = 6 } })

-----------------
-- LAYER RULES --
-----------------

hl.layer_rule({ match = { namespace = "quickshell" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.5, no_anim = true })
