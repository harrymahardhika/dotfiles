#!/usr/bin/env bash
# hypr-binds.sh — rofi picker for Hyprland keybinds.
# Parses ~/.config/hypr/hyprland.lua for hl.bind() calls, shows them in rofi,
# and executes the selected action via `hyprctl dispatch`.
# Usage: hypr-binds.sh [--list]   (--list prints label<TAB>dispatch without rofi)
set -euo pipefail

CONFIG="${HYPR_CONFIG:-$HOME/.config/hypr/hyprland.lua}"

command -v rofi >/dev/null 2>&1 || { echo "rofi is required" >&2; exit 1; }
command -v hyprctl >/dev/null 2>&1 || { echo "hyprctl is required" >&2; exit 1; }
[ -f "$CONFIG" ] || { echo "config not found: $CONFIG" >&2; exit 1; }

# Keep in sync with the "=== CONSTANTS ===" section of hyprland.lua.
TERMINAL_CMD="$(sed -n 's/.*local terminal = "\([^"]*\)".*/\1/p' "$CONFIG" | head -n1)"
TERMINAL_CMD="${TERMINAL_CMD:-ghostty}"
BROWSER="$(sed -n 's/.*local browser = "\([^"]*\)".*/\1/p' "$CONFIG" | head -n1)"
BROWSER="${BROWSER:-zen-browser}"
MENU_CMD="$(sed -n 's/.*local menu = "\([^"]*\)".*/\1/p' "$CONFIG" | head -n1)"
MENU_CMD="${MENU_CMD:-rofi -show drun}"

# ---- Extract hl.bind(...) chunks with awk (paren-balance aware, handles
# multiline binds) and emit one TSV line per bind: mod \t key \t method \t args
awk_prog=$(cat <<'AWK'
function clean(s,   c) {
	gsub(/[\t\r\n]+/, " ", s)
	gsub(/^ +| +$/, "", s)
	return s
}
function get_balanced(s, start,   i, c, depth) {
	depth = 0
	for (i = start; i <= length(s); i++) {
		c = substr(s, i, 1)
		if (c == "(") depth++
		else if (c == ")") depth--
		if (depth == 0) return i
	}
	return length(s)
}
function process(s,   mod, key, tmp, kv, after, lp, e, args, rest, q) {
	s = clean(s)
	if (s !~ /hl\.bind\(/) return
	mod = ""; key = ""
	if (match(s, /hl\.bind\(kb\(/)) {
		lp = RSTART + RLENGTH - 1
		e = get_balanced(s, lp)
		tmp = substr(s, lp + 1, e - lp - 1)
		split(tmp, kv, ",")
		mod = kv[1]; gsub(/[\t "]+/, "", mod)
		key = kv[2]; gsub(/[\t "]+/, "", key)
	} else if (match(s, /hl\.bind\([ \t]*"/)) {
		rest = substr(s, RSTART + RLENGTH)
		q = index(rest, "\"")
		key = substr(rest, 1, q - 1)
	}
	if (key == "" || key ~ /mouse/) return
	if (!match(s, /hl\.dsp\./)) return
	after = substr(s, RSTART + RLENGTH)
	lp = index(after, "(")
	if (lp == 0) return
	method = substr(after, 1, lp - 1)
	e = get_balanced(after, lp)
	args = clean(substr(after, lp + 1, e - lp - 1))
	print (mod == "" ? "-" : mod) "\t" key "\t" method "\t" args
}
/^[ \t]*hl\.bind\(/ {
	inbind = 1
	depth = 0
	buf = $0
}
{
	if (inbind) {
		if (buf != $0) buf = buf " " $0
		for (i = 1; i <= length($0); i++) {
			c = substr($0, i, 1)
			if (c == "(") depth++
			else if (c == ")") depth--
		}
		if (depth <= 0) {
			process(buf)
			inbind = 0
			depth = 0
			buf = ""
		}
	}
}
AWK
)

# ---- Helpers to translate a parsed bind into (label, dispatch) ----

field_val() {
	sed -n "s/.*${1}[[:space:]]*=[[:space:]]*\([^,}]*\).*/\1/p" <<<"$2" | tr -d '" '
}

# Expand a Lua exec_cmd(...) argument into a runnable shell command.
eval_exec_args() {
	local cmd="$1"
	cmd="${cmd//terminal/$TERMINAL_CMD}"
	cmd="${cmd//browser/$BROWSER}"
	cmd="${cmd//menu/$MENU_CMD}"
	cmd="${cmd// .. /}"
	cmd="${cmd//\"}"
	cmd="${cmd//\$HOME/$HOME}"
	cmd="${cmd/\~/$HOME}"
	echo "$cmd"
}

describe_command() {
	local cmd="$1"
	case "$cmd" in
		"$TERMINAL_CMD") echo "Open terminal" ;;
		"$TERMINAL_CMD -e yazi") echo "File manager (yazi)" ;;
		"$BROWSER") echo "Open browser" ;;
		"$MENU_CMD") echo "Application launcher" ;;
		*reload.sh*) echo "Reload Hyprland" ;;
		hyprlock|*swaylock.sh*) echo "Lock screen" ;;
		*set-wallpaper.sh*) echo "Random wallpaper" ;;
		*theme-pick.sh*) echo "Pick theme" ;;
		*power-pick.sh*) echo "Pick power scheme" ;;
		*power-menu.sh*) echo "Power menu (lock/suspend/logout/reboot/shutdown)" ;;
		*waybar*toggle*) echo "Toggle waybar" ;;
		*toggle-transparency.sh*) echo "Toggle window transparency" ;;
		*clipboard-history.sh*) echo "Clipboard history" ;;
		"$TERMINAL_CMD -e btop") echo "Task manager (btop)" ;;
		*webapp-launcher.sh*) echo "Webapp launcher" ;;
		*notif-center.sh*) echo "Notification center" ;;
		*hypr-binds.sh*) echo "Keybind picker" ;;
		*hyprshot\ -m\ window*) echo "Screenshot window" ;;
		*hyprshot\ -m\ output*) echo "Screenshot output" ;;
		*hyprshot*) echo "Screenshot region" ;;
		*wpctl\ set-volume*5%+*) echo "Volume up" ;;
		*wpctl\ set-volume*5%-*) echo "Volume down" ;;
		*set-mute*SINK*) echo "Mute" ;;
		*set-mute*SOURCE*) echo "Mic mute" ;;
		*brightnessctl\ s\ 10%+*) echo "Brightness up" ;;
		*brightnessctl\ s\ 10%-*) echo "Brightness down" ;;
		*) echo "$cmd" ;;
	esac
}

key_display() {
	case "$1" in
		RETURN) echo "Enter" ;;
		SPACE) echo "Space" ;;
		period) echo "." ;;
		comma) echo "," ;;
		HOME) echo "Home" ;;
		END) echo "End" ;;
		bracketleft) echo "[" ;;
		bracketright) echo "]" ;;
		*) echo "$1" ;;
	esac
}

# ---- Build label/dispatch arrays ----

declare -a LABELS=() DISPATCH=()

while IFS=$'\t' read -r mod key method args; do
	[ "$mod" = "-" ] && mod=""
	case "$mod" in
		mainMod) mod="SUPER" ;;
		modShift) mod="SUPER + SHIFT" ;;
	esac

	# Workspaces are a static loop in the config: for i in 1..10, key = i % 10
	if [ "$key" = "tostring(key)" ]; then
		for i in {1..10}; do
			wkey=$((i % 10))
			case "$method" in
				focus) disp="hl.dsp.focus({ workspace = $i })"; desc="Go to workspace $i" ;;
				window.move) disp="hl.dsp.window.move({ workspace = $i })"; desc="Move window to workspace $i" ;;
				*) continue ;;
			esac
			LABELS+=("$(printf '%-22s %s' "$mod + $wkey" "$desc")")
			DISPATCH+=("$disp")
		done
		continue
	fi

	kd="$(key_display "$key")"
	if [ -n "$mod" ]; then
		label="$mod + $kd"
	elif [[ "$key" != XF86* ]]; then
		label="Resize: $kd"
	else
		label="$kd"
	fi

	case "$method" in
		exec_cmd)
			cmd="$(eval_exec_args "$args")"
			disp="hl.dsp.exec_cmd(\"$cmd\")"
			desc="$(describe_command "$cmd")"
			;;
		window.close) disp="hl.dsp.window.close()"; desc="Close window" ;;
		exit) disp="hl.dsp.exit()"; desc="Exit Hyprland" ;;
		window.float) disp="hl.dsp.window.float({ action = 'toggle' })"; desc="Toggle floating window" ;;
		layout)
			arg="${args//\"}"
			disp="hl.dsp.layout('$arg')"
			case "$arg" in
				pseudo) desc="Toggle pseudo-tiling" ;;
				"swapcol r") desc="Swap column right" ;;
				"swapcol l") desc="Swap column left" ;;
				"colresize -0.1") desc="Resize column smaller" ;;
				"colresize +0.1") desc="Resize column larger" ;;
				consume) desc="Merge window into previous column" ;;
				expel) desc="Move window to own column" ;;
				promote) desc="Move window to new column" ;;
				"fit expand") desc="Expand window to fill free space" ;;
				fit_into_view) desc="Fit column into view" ;;
				inhibit_scroll) desc="Toggle auto-scroll on workspace" ;;
				"move +col") desc="Pan view right" ;;
				"move -col") desc="Pan view left" ;;
				"fit tobeg") desc="Jump to start of tape" ;;
				"fit toend") desc="Jump to end of tape" ;;
				"colresize +conf") desc="Column width preset (wider)" ;;
				"colresize -conf") desc="Column width preset (narrower)" ;;
				*) desc="Layout: $arg" ;;
			esac
			;;
		window.fullscreen)
			if [[ "$args" == *maximized* ]]; then
				disp="hl.dsp.window.fullscreen({ mode = 'maximized', action = 'toggle' })"
				desc="Toggle maximized window"
			else
				disp="hl.dsp.window.fullscreen({ action = 'toggle' })"
				desc="Toggle fullscreen"
			fi
			;;
		focus)
			if [[ "$args" == *direction* ]]; then
				dir="$(field_val direction "$args")"
				disp="hl.dsp.focus({ direction = '$dir' })"
				desc="Focus ${dir^}"
			elif [[ "$args" == *workspace* ]]; then
				ws="$(field_val workspace "$args")"
				disp="hl.dsp.focus({ workspace = $ws })"
				desc="Go to workspace $ws"
			fi
			;;
		window.move)
			if [[ "$args" == *direction* ]]; then
				dir="$(field_val direction "$args")"
				disp="hl.dsp.window.move({ direction = '$dir' })"
				desc="Move window ${dir^}"
			elif [[ "$args" == *workspace* ]]; then
				ws="$(field_val workspace "$args")"
				if [[ "$ws" =~ ^[0-9]+$ ]]; then
					disp="hl.dsp.window.move({ workspace = $ws })"
					desc="Move window to workspace $ws"
				else
					disp="hl.dsp.window.move({ workspace = '$ws' })"
					desc="Move window to $ws"
				fi
			fi
			;;
		workspace.toggle_special)
			arg="${args//\"}"
			disp="hl.dsp.workspace.toggle_special('$arg')"
			desc="Toggle scratchpad: $arg"
			;;
		submap)
			arg="${args//\"}"
			disp="hl.dsp.submap('$arg')"
			if [ "$arg" = "resize" ]; then desc="Enter resize mode"; else desc="Exit resize mode"; fi
			;;
		window.resize)
			disp="hl.dsp.window.resize($args)"
			desc="Resize window"
			;;
		*)
			continue
			;;
	esac

	[ -n "${disp:-}" ] || continue
	LABELS+=("$(printf '%-22s %s' "$label" "$desc")")
	DISPATCH+=("$disp")
done < <(awk "$awk_prog" "$CONFIG")

[ ${#LABELS[@]} -gt 0 ] || { echo "no binds parsed from $CONFIG" >&2; exit 1; }

if [ "${1:-}" = "--list" ]; then
	for i in "${!LABELS[@]}"; do
		printf '%s\t%s\n' "${LABELS[$i]}" "${DISPATCH[$i]}"
	done
	exit 0
fi

sel=$(printf '%s\n' "${LABELS[@]}" | rofi -dmenu -i -no-custom -p " Binds " -format i \
	-theme-str 'window {height: 520px;}' -theme-str 'listview {columns: 1; lines: 14;}') || true

[ -n "$sel" ] || exit 0
[ "$sel" -lt ${#DISPATCH[@]} ] || exit 0

exec hyprctl dispatch "${DISPATCH[$sel]}"
