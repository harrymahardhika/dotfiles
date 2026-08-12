-- Hyprland Lua Config

---@diagnostic disable: undefined-global

-- === MONITORS ===
pcall(dofile, os.getenv("HOME") .. "/.config/hypr/monitors.lua")

-- === CONFIG ===
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
		active_opacity = 0.90,
		inactive_opacity = 0.80,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.4,
			contrast = 1.0,
			brightness = 1.0,
			new_optimizations = true,
		},
	},
	animations = {
		enabled = true,
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
		mouse_move_enables_dpms = true,
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

-- === WINDOW RULES ===
local floating_dialogs = {
	{ match = { class = "pavucontrol" }, float = true },
	{ match = { class = "blueman-manager" }, float = true },
	{ match = { class = "nm-connection-editor" }, float = true },
	{ match = { class = "org.gnome.Calculator" }, float = true },
	{ match = { class = "XDG-Desktop-Portal" }, float = true },
}
for _, rule in ipairs(floating_dialogs) do
	hl.window_rule(rule)
end

-- === CURVES ===
hl.curve("snap", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

-- === ANIMATIONS ===
local anim_speed = 1.0
local animations = {
	{ leaf = "global", speed = 8 * anim_speed, bezier = "default" },
	{ leaf = "border", speed = 8 * anim_speed, bezier = "snap" },
	{ leaf = "windows", speed = 8 * anim_speed, bezier = "snap" },
	{ leaf = "windowsIn", speed = 8 * anim_speed, bezier = "snap", style = "popin 87%" },
	{ leaf = "windowsOut", speed = 4 * anim_speed, bezier = "snap", style = "popin 87%" },
	{ leaf = "fadeIn", speed = 4 * anim_speed, bezier = "snap" },
	{ leaf = "fadeOut", speed = 4 * anim_speed, bezier = "snap" },
	{ leaf = "fade", speed = 7 * anim_speed, bezier = "snap" },
	{ leaf = "layers", speed = 7 * anim_speed, bezier = "snap" },
	{ leaf = "layersIn", speed = 8 * anim_speed, bezier = "snap", style = "fade" },
	{ leaf = "layersOut", speed = 4 * anim_speed, bezier = "snap", style = "fade" },
	{ leaf = "fadeLayersIn", speed = 4 * anim_speed, bezier = "snap" },
	{ leaf = "fadeLayersOut", speed = 4 * anim_speed, bezier = "snap" },
	{ leaf = "workspaces", speed = 8 * anim_speed, bezier = "snap", style = "fade" },
	{ leaf = "workspacesIn", speed = 8 * anim_speed, bezier = "snap", style = "fade" },
	{ leaf = "workspacesOut", speed = 8 * anim_speed, bezier = "snap", style = "fade" },
}
for _, a in ipairs(animations) do
	a.enabled = true
	hl.animation(a)
end

-- === CONSTANTS ===
local terminal = "ghostty"
local menu = "rofi -show drun"
local browser = "zen-browser"
local mainMod = "SUPER"
local modShift = "SUPER + SHIFT"

-- === GESTURES ===
hl.gesture({
	fingers = 3,
	direction = "l",
	action = function()
		hl.dispatch(hl.dsp.window.cycle_next("prev"))
	end,
})
hl.gesture({
	fingers = 3,
	direction = "r",
	action = function()
		hl.dispatch(hl.dsp.window.cycle_next())
	end,
})

-- === AUTOSTART ===
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd(terminal .. " -e $HOME/scripts/set-gtk-dark-mode.sh")
	hl.exec_cmd("dropbox")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("awww-daemon --format xrgb")
	hl.exec_cmd(
		"bash -c 'while true; do \"$HOME/.config/i3/battery-warning.sh\" >> /tmp/battery-warning.log 2>&1; sleep 60; done'"
	)
	hl.exec_cmd(terminal .. " -e $HOME/.config/hypr/set-wallpaper.sh")
end)

-- === ENVIRONMENT ===
hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("XCURSOR_THEME", "catppuccin-mocha")

-- kb(mod, key) returns "mod + key"
local function kb(mod, key)
	return mod .. " + " .. key
end

-- === APPLICATION SHORTCUTS ===
hl.bind(kb(mainMod, "RETURN"), hl.dsp.exec_cmd(terminal))
hl.bind(kb(mainMod, "Q"), hl.dsp.window.close())
hl.bind(kb(mainMod, "E"), hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(kb(mainMod, "M"), hl.dsp.exec_cmd(browser))
hl.bind(kb(modShift, "R"), hl.dsp.exec_cmd("$HOME/.config/hypr/reload.sh"))
hl.bind(kb(modShift, "Q"), hl.dsp.exit())
hl.bind(kb(modShift, "X"), hl.dsp.exec_cmd("hyprlock"))
hl.bind(kb(modShift, "SPACE"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(kb(mainMod, "D"), hl.dsp.exec_cmd(menu))
hl.bind(kb(mainMod, "F"), hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(kb(mainMod, "G"), hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(kb(modShift, "W"), hl.dsp.exec_cmd("$HOME/.config/hypr/set-wallpaper.sh"))
hl.bind(kb(mainMod, "S"), hl.dsp.exec_cmd("$HOME/scripts/theme-pick.sh"))
hl.bind(kb(mainMod, "B"), hl.dsp.exec_cmd("~/.config/waybar/scripts/toggle.sh"))
hl.bind(kb(modShift, "T"), hl.dsp.exec_cmd("$HOME/.config/hypr/toggle-transparency.sh"))
hl.bind(kb(mainMod, "V"), hl.dsp.exec_cmd("$HOME/scripts/clipboard-history.sh"))
hl.bind(kb(mainMod, "A"), hl.dsp.exec_cmd("$HOME/scripts/webapp-launcher.sh"))
hl.bind(kb(mainMod, "slash"), hl.dsp.exec_cmd("$HOME/scripts/hypr-binds.sh"))

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
	local key = i % 10 -- 0 → workspace 10
	hl.bind(kb(mainMod, tostring(key)), hl.dsp.focus({ workspace = i }))
	hl.bind(kb(modShift, tostring(key)), hl.dsp.window.move({ workspace = i }))
end

-- === RESIZE SUBMAP ===
hl.define_submap("resize", function()
	hl.bind("h", hl.dsp.layout("colresize -0.1"), { repeating = true })
	hl.bind("l", hl.dsp.layout("colresize +0.1"), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -80, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 80, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -80, y = 0, relative = true }), { repeating = true })
	hl.bind("right", hl.dsp.window.resize({ x = 80, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -80, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 80, relative = true }), { repeating = true })
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
hl.bind(kb(mainMod, "P"), hl.dsp.exec_cmd("env HYPRSHOT_DIR=$HOME/Screenshots hyprshot -m window"))
hl.bind(kb(modShift, "P"), hl.dsp.exec_cmd("env HYPRSHOT_DIR=$HOME/Screenshots hyprshot -m region"))

-- === SCRATCHPAD (special workspace) ===
hl.bind(kb(mainMod, "Z"), hl.dsp.workspace.toggle_special("scratch"))
hl.bind(kb(modShift, "Z"), hl.dsp.window.move({ workspace = "special:scratch" }))

hl.window_rule({
	match = { workspace = "special:scratch" },
	float = true,
	center = true,
	size = "80% 80%",
})

-- === SCROLLING LAYOUT ===
hl.bind(kb(mainMod, "period"), hl.dsp.layout("swapcol r"))
hl.bind(kb(mainMod, "comma"), hl.dsp.layout("swapcol l"))
hl.bind(kb(modShift, "period"), hl.dsp.layout("move +col"))
hl.bind(kb(modShift, "comma"), hl.dsp.layout("move -col"))
hl.bind(kb(mainMod, "HOME"), hl.dsp.layout("fit tobeg"))
hl.bind(kb(mainMod, "END"), hl.dsp.layout("fit toend"))
hl.bind(kb(mainMod, "bracketright"), hl.dsp.layout("colresize +conf"))
hl.bind(kb(mainMod, "bracketleft"), hl.dsp.layout("colresize -conf"))
hl.bind(kb(mainMod, "C"), hl.dsp.layout("consume"))
hl.bind(kb(mainMod, "X"), hl.dsp.layout("expel"))
hl.bind(kb(modShift, "N"), hl.dsp.layout("promote"))
hl.bind(kb(modShift, "F"), hl.dsp.layout("fit expand"))
hl.bind(kb(modShift, "V"), hl.dsp.layout("fit_into_view"))
hl.bind(kb(modShift, "I"), hl.dsp.layout("inhibit_scroll"))

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
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(
		"brightnessctl s 10%+ && notify-send -h 'int:value:'$(brightnessctl -m | cut -d, -f4 | tr -d %) 'Brightness '$(brightnessctl -m | cut -d, -f4)"
	),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(
		"brightnessctl s 10%- && notify-send -h 'int:value:'$(brightnessctl -m | cut -d, -f4 | tr -d %) 'Brightness '$(brightnessctl -m | cut -d, -f4)"
	),
	{ repeating = true, locked = true }
)

-- === DYNAMIC OVERRIDES ===
pcall(dofile, "/tmp/hypr-opacity.lua")
