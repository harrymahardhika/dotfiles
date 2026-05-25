-- Hyprland Lua Config

---@diagnostic disable: undefined-global

-- Monitors
hl.monitor({ output = "HDMI-A-2", mode = "1920x1080", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "1920x0", scale = 1 })

-- General settings
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 0,
		resize_on_border = false,
		allow_tearing = false,
		layout = "scrolling",
	},
	decoration = {
		rounding = 4,
		active_opacity = 0.95,
		inactive_opacity = 0.70,
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = true,
		bezier = {
			{ name = "snap", p1 = { 0.05, 0.9 }, p2 = { 0.1, 1 } },
			{ name = "easeOutQuint", p1 = { 0.23, 1 }, p2 = { 0.32, 1 } },
			{ name = "linear", p1 = { 0, 0 }, p2 = { 1, 1 } },
		},
		animation = {
			{ name = "global", enabled = true, speed = 10, curve = "default" },
			{ name = "border", enabled = true, speed = 8, curve = "snap" },
			{ name = "windows", enabled = true, speed = 8, curve = "snap" },
			{ name = "windowsIn", enabled = true, speed = 8, curve = "snap", style = "popin 87%" },
			{ name = "windowsOut", enabled = true, speed = 6, curve = "snap", style = "popin 87%" },
			{ name = "fadeIn", enabled = true, speed = 6, curve = "snap" },
			{ name = "fadeOut", enabled = true, speed = 6, curve = "snap" },
			{ name = "fade", enabled = true, speed = 7, curve = "snap" },
			{ name = "layers", enabled = true, speed = 7, curve = "snap" },
			{ name = "layersIn", enabled = true, speed = 8, curve = "snap", style = "fade" },
			{ name = "layersOut", enabled = true, speed = 6, curve = "snap", style = "fade" },
			{ name = "fadeLayersIn", enabled = true, speed = 6, curve = "snap" },
			{ name = "fadeLayersOut", enabled = true, speed = 6, curve = "snap" },
			{ name = "workspaces", enabled = true, speed = 10, curve = "snap", style = "fade" },
			{ name = "workspacesIn", enabled = true, speed = 10, curve = "snap", style = "fade" },
			{ name = "workspacesOut", enabled = true, speed = 10, curve = "snap", style = "fade" },
		},
	},
	input = {
		kb_layout = "us",
		kb_options = "ctrl:nocaps",
		numlock_by_default = true,
		natural_scroll = true,
		follow_mouse = 1,
		sensitivity = 0,
		repeat_rate = 50,
		repeat_delay = 250,
		touchpad = {
			natural_scroll = true,
		},
	},
	device = {
		{ name = "epic-mouse-v1", sensitivity = -0.5 },
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	scrolling = {
		column_width = 0.75,
	},
})

local terminal = "ghostty"
local menu = "rofi -show drun"
local browser = "zen-browser"
local mainMod = "SUPER"
local modShift = "SUPER + SHIFT"

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd(terminal .. " -e $HOME/scripts/set-gtk-dark-mode.sh")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("dropbox")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("awww-daemon --format xrgb")
	hl.exec_cmd("bash -c 'while true; do \"$HOME/.config/i3/battery-warning.sh\"; sleep 60; done'")
	hl.exec_cmd(terminal .. " -e $HOME/.config/hypr/set-wallpaper.sh")
end)

hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")

local function kb(mod, key)
	return mod .. " + " .. key
end

-- === APPLICATION SHORTCUTS ===
hl.bind(kb(mainMod, "RETURN"), hl.dsp.exec_cmd(terminal))
hl.bind(kb(mainMod, "Q"), hl.dsp.window.close())
hl.bind(kb(mainMod, "M"), hl.dsp.exec_cmd(browser))
hl.bind(kb(modShift, "R"), hl.dsp.exec_cmd("$HOME/.config/hypr/reload.sh"))
hl.bind(kb(modShift, "E"), hl.dsp.exit())
hl.bind(kb(modShift, "X"), hl.dsp.exec_cmd("hyprlock"))
hl.bind(kb(modShift, "SPACE"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(kb(mainMod, "D"), hl.dsp.exec_cmd(menu))
hl.bind(kb(mainMod, "P"), hl.dsp.layout("pseudo"))
hl.bind(kb(mainMod, "F"), hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(kb(mainMod, "G"), hl.dsp.window.fullscreen_state({ internal = -1, client = -1, action = "toggle" }))
hl.bind(kb(modShift, "W"), hl.dsp.exec_cmd("$HOME/.config/hypr/set-wallpaper.sh"))
hl.bind(kb(mainMod, "B"), hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(kb(modShift, "T"), hl.dsp.exec_cmd("$HOME/.config/hypr/toggle-transparency.sh"))

-- Gap controls
hl.bind(
	kb(modShift, "Minus"),
	hl.dsp.exec_cmd("hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0")
)
hl.bind(
	kb(mainMod, "Minus"),
	hl.dsp.exec_cmd("hyprctl keyword general:gaps_in 2 && hyprctl keyword general:gaps_out 4")
)

-- Clipboard history
hl.bind(kb(mainMod, "V"), hl.dsp.exec_cmd("$HOME/scripts/clipboard-history.sh"))

-- Layout controls
hl.bind(kb(modShift, "B"), hl.dsp.layout("preselect l"))
hl.bind(kb(modShift, "V"), hl.dsp.layout("preselect d"))
hl.bind(kb(mainMod, "W"), hl.dsp.exec_cmd("hyprctl keyword general:layout scrolling"))
hl.bind(kb(mainMod, "E"), hl.dsp.exec_cmd("hyprctl keyword general:layout dwindle"))
hl.bind(kb(mainMod, "A"), hl.dsp.exec_cmd("$HOME/scripts/webapp-launcher.sh"))

-- === MOVE FOCUS ===
hl.bind(kb(mainMod, "left"), hl.dsp.focus({ direction = "left" }))
hl.bind(kb(mainMod, "right"), hl.dsp.focus({ direction = "right" }))
hl.bind(kb(mainMod, "up"), hl.dsp.focus({ direction = "up" }))
hl.bind(kb(mainMod, "down"), hl.dsp.focus({ direction = "down" }))
hl.bind(kb(mainMod, "H"), hl.dsp.focus({ direction = "left" }))
hl.bind(kb(mainMod, "J"), hl.dsp.focus({ direction = "down" }))
hl.bind(kb(mainMod, "K"), hl.dsp.focus({ direction = "up" }))
hl.bind(kb(mainMod, "L"), hl.dsp.focus({ direction = "right" }))

-- === MOVE WINDOWS ===
hl.bind(kb(modShift, "H"), hl.dsp.window.move({ direction = "left" }))
hl.bind(kb(modShift, "J"), hl.dsp.window.move({ direction = "down" }))
hl.bind(kb(modShift, "K"), hl.dsp.window.move({ direction = "up" }))
hl.bind(kb(modShift, "L"), hl.dsp.window.move({ direction = "right" }))

-- === WORKSPACES ===
for i = 1, 10 do
	local key = i % 10
	hl.bind(kb(mainMod, tostring(key)), hl.dsp.focus({ workspace = i }))
	hl.bind(kb(modShift, tostring(key)), hl.dsp.window.move({ workspace = i }))
end

-- === RESIZE SUBMAP ===
hl.define_submap("resize", function()
	hl.bind("h", hl.dsp.layout("colresize -0.1"), { repeating = true })
	hl.bind("l", hl.dsp.layout("colresize +0.1"), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
	hl.bind("right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
	hl.bind("return", hl.dsp.submap("reset"))
	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(kb(mainMod, "R"), hl.dsp.submap("resize"))

-- === MOUSE ===
hl.bind(kb(mainMod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(kb(mainMod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }))
hl.bind(kb(mainMod, "mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(kb(mainMod, "mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- === SCREENSHOT ===
hl.bind(kb(modShift, "P"), hl.dsp.exec_cmd("env HYPRSHOT_DIR=$HOME/Screenshots hyprshot -m region"))

-- === SCROLLING LAYOUT ===
hl.bind(kb(mainMod, "period"), hl.dsp.layout("swapcol r"))
hl.bind(kb(mainMod, "comma"), hl.dsp.layout("swapcol l"))

-- === MEDIA KEYS ===
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true, locked = true })

pcall(dofile, "/tmp/hypr-opacity.lua")
