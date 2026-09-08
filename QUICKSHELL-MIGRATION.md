# Quickshell Migration TODO

Plan for migrating the desktop shell (bar, notifications, OSD, lockscreen)
from the current Waybar+rofi+mako+hyprlock stack to a from-scratch
Quickshell (Qt/QML) config, on Arch + Hyprland, dotfiles managed via GNU
Stow.

**rofi is staying permanently**, not being migrated. It's already the
picker/menu primitive everywhere (drun launcher, `hypr-binds.sh`,
`notif-center.sh`, `theme-pick.sh`, `clipboard-history.sh`,
`webapp-launcher.sh`) and that's fine — no reason to rewrite a working
launcher just because the rest of the shell moves to QML. rofi is shared
by both legacy and quickshell modes, same as hypridle/awww, and is not
part of the toggle.

**Ground rules for this migration:**

- **No existing Quickshell config is used as a base.** Every file under
  `.config/quickshell/` is written from scratch. Reference configs
  (end-4/dots-hyprland, caelestia-dots/shell, DankMaterialShell) may be
  *read* for patterns (how they structure IPC singletons, layer-shell
  windows, theming singletons) but nothing is copied or cloned-and-edited.
- **Switching is one global toggle**, not per-module. Old stack
  (waybar+mako+hyprlock) and new stack (Quickshell) are mutually
  exclusive at runtime — never run both bars, both notification servers,
  etc. at once. rofi, hypridle, and awww are shared by both sides and are
  not toggled.
- **Incremental build, atomic switch.** Modules are *built* one at a time
  against the order below, but the toggle itself flips the whole shell in
  one step once a module is ready — see §2.

Full inventory and component-by-component Quickshell mapping already done;
see conversation history / regenerate with a fresh review if this file goes
stale. This file tracks the actual migration work.

---

## 0. Current stack (baseline, for the toggle to restore)

Confirmed active (not just present) via `graphical-session.target.wants` /
`default.target.wants` and `hyprland.lua` exec-once calls:

- Bar: **waybar** (`waybar.service`)
- Launcher: **rofi** (`-show drun`, plus reused as generic picker in
  `hypr-binds.sh`, `notif-center.sh`, `theme-pick.sh`, `clipboard-history.sh`,
  `webapp-launcher.sh`) — **staying permanently, not migrated, not part of
  the toggle**
- Notifications: **mako** (`mako.service`, DBus-activated,
  `org.freedesktop.Notifications`)
- OSD: none dedicated — `notify-send -h int:value:N` via mako, from
  `hyprland.lua` media-key binds
- Lockscreen: **hyprlock** (invoked by hypridle's `lock_cmd`)
- Idle daemon: **hypridle** (`hypridle.service`) — **not replaced**, no
  Quickshell equivalent exists
- Wallpaper: **awww** (`awww-daemon.service` + `set-wallpaper.sh`) — **not
  replaced**, no Quickshell equivalent exists
- System tray: **none today** — waybar's config has no tray module, and
  `udiskie.service` runs with `--no-tray` explicitly. Wanted as a new
  addition in the Quickshell bar (USB via udiskie, Dropbox) — see §3 step 1.
- Dead weight, not touched by this migration: dunst, wofi, sway/i3/swayidle
  configs (present in repo, not enabled anywhere)

---

## 1. Repo/stow scaffolding

- [ ] Add `.config/quickshell/` under the existing flat single-package stow
      tree (no new stow package — `stow .` already symlinks everything from
      repo root, per `AGENTS.md`).
- [ ] Internal structure: `shell.qml` entrypoint + `modules/` (bar, launcher,
      osd, notifications, lock) + `services/` (Hyprland IPC, Pipewire,
      UPower, theme singleton) + `config/`.
- [ ] `services/Theme.qml`: a `Singleton` using `FileView` to read
      `~/.cache/theme-current` (already maintained by `theme-switch.sh`) and
      `themes/palettes/<name>.palette` directly at runtime. No sed/generation
      step, no new `apply_quickshell_*` substitution function needed — this
      is simpler than every other `apply_*` in `theme-switch.sh`, confirm
      that simplification actually works before relying on it.
- [ ] Add whatever local Quickshell cache dir it uses to `.gitignore`
      (check once installed — analogous to existing `lazy-lock.json` /
      `btop/*.conf` exclusions).
- [ ] Update `AGENTS.md` with a `## Quickshell` section once the toggle
      script exists (mirror the `## Theme Switching` section style).

## 2. The global toggle

- [ ] `scripts/shell-switch.sh legacy|quickshell|current` (name TBD to match
      existing `theme-switch.sh`/`nvim-switch.sh` conventions).
  - `quickshell`: stop `waybar.service` + `mako.service`, start the
    Quickshell process (own systemd user unit,
    `quickshell.service`, so it restarts like the others), point
    `hypridle.conf`'s `lock_cmd` at the Quickshell lock invocation instead
    of `hyprlock` (only once lockscreen module exists — until then hypridle
    keeps using hyprlock even in "quickshell" mode, see §3 step 5).
  - `legacy`: reverse — stop `quickshell.service`, start
    `waybar.service` + `mako.service`, restore hypridle's `lock_cmd` to
    hyprlock.
  - Track active choice in a state file alongside `~/.cache/theme-current`
    (e.g. `~/.cache/shell-current`), same pattern.
  - Must be safe to run mid-session repeatedly without leaking processes
    (check `pidof`/`systemctl is-active` before acting, same style as
    `set-wallpaper.sh`'s `pgrep` guard).
- [ ] Rebind `$mod+Shift+B` or add a new bind in `hyprland.lua` to invoke
      the toggle (current `$mod+Shift+B` is `waybar-style.sh toggle`, decide
      whether to repurpose or pick a new key).
- [ ] Verify `theme-switch.sh apply` still works correctly under whichever
      shell is active (its `reload_apps()` currently unconditionally
      restarts `mako.service`/`waybar.service` — gate those restarts on
      which shell is active so switching themes doesn't spawn the stack
      you're not using).

## 3. Module build order (risk/complexity-driven)

Each step: build the QML module, manually verify it standalone, *then* wire
it into the toggle script. Old stack stays the default/fallback until a
module is confirmed working.

1. [ ] **Bar** (Med effort) — `PanelWindow`, Hyprland IPC
       (workspaces/active window/submap), Pipewire (volume — reused by OSD
       later), UPower (battery), reimplement `custom/cpu_temp` via
       `Quickshell.Io.Process` wrapping the existing
       `waybar/scripts/cpu-temp.sh`, backlight (no stock service — wrap
       `brightnessctl` via `Process`), network, clock.
   - [ ] **System tray** (new — not in current waybar config, no tray icon
         exists anywhere in the current setup) —
         `Quickshell.Services.SystemTray` (StatusNotifierItem, no GTK-tray
         dependency). Wanted for USB (udiskie) and Dropbox specifically:
         - [ ] `udiskie.service` currently runs `--no-tray --notify
               --automount`; **drop `--no-tray`** so it registers a
               StatusNotifierItem, and decide whether to keep or drop
               `--notify` once tray + Quickshell notifications both exist,
               to avoid double-reporting mount events.
         - [ ] Check whether the installed `dropbox` binary registers a
               StatusNotifierItem itself (many builds do natively) before
               writing any custom wrapper for it — likely needs no
               Quickshell-side code at all, just the tray module existing.
         - [ ] Verify with `busctl --user list | grep StatusNotifier` (or
               similar) which apps actually register once tray is live, add
               them one at a time rather than assuming.
2. [ ] **OSD** (Low effort) — volume/brightness popup bound to the same
       Pipewire/brightnessctl sources as the bar. Replaces the
       `notify-send -h int:value:N` calls in `hyprland.lua`'s media-key
       binds — update those binds once this lands.
3. [ ] **Notifications** (Med effort, DBus-exclusive cutover) —
       `Quickshell.Services.Notifications` server + toast rendering + a
       history panel (directly replaces `notif-center.sh`'s
       `makoctl history -j` + rofi hack — the service exposes history
       natively). mako must be fully stopped when this is active, only one
       process can own `org.freedesktop.Notifications` — handled by the
       toggle script, not by running both.
4. [ ] **Lockscreen** (High effort, highest blast-radius — optional/last) —
       `WlSessionLockSurface`, reproduce `hyprlock.conf`'s layout
       (clock/date/battery/uptime/capslock as reactive bindings instead of
       `cmd[update:N]` polling, profile picture, screenshot-blur
       background). Security-sensitive: verify it actually blocks input
       correctly before relying on it, keep hyprlock installed as manual
       fallback (`hyprlock` binary/config untouched even after this is
       "done"). Only rewire hypridle's `lock_cmd` in the toggle script once
       this is verified solid.

## 4. Explicitly not migrating

- **rofi** — staying permanently as the launcher/picker primitive
  (drun launcher, `hypr-binds.sh`, `notif-center.sh`, `theme-pick.sh`,
  `clipboard-history.sh`, `webapp-launcher.sh`). Shared by both legacy and
  quickshell modes, untouched by the toggle. `notif-center.sh` keeps
  driving off `makoctl history -j` in legacy mode; once step 3
  (notifications) lands, point it at whatever history query Quickshell's
  `Notifications` service exposes instead, but the rofi UI itself doesn't
  change.
- **hypridle** — no Quickshell idle-timeout equivalent exists. Stays as-is,
  shared by both legacy and quickshell modes; only its `lock_cmd` target
  changes based on which lockscreen is active.
- **awww wallpaper daemon** — no Quickshell wallpaper equivalent exists.
  Stays as-is, shared by both modes, untouched by the toggle.
- Also worth fixing independent of this migration: redundant `awww-daemon`
  start (both `exec-once` in `hyprland.lua` *and*
  `awww-daemon.service`) — not in scope here, note only.

## 5. Reference material (read-only, no copying)

Pattern references only — consulted for IPC singleton structure, layer-shell
window setup, and theming-singleton approach. No file from these is copied
or used as an edit base:

- end-4/dots-hyprland — closest precedent for wiring an external palette
  file into QML reactively (comparable to what `theme-switch.sh` already
  does via substitution).
- caelestia-dots/shell — cleaner `services/` vs `modules/` separation,
  useful for the Hyprland-IPC/Pipewire/UPower singleton pattern.
- DankMaterialShell — complete reference for the full component set
  (bar/OSD/notifications/lock — its launcher module isn't relevant here
  since rofi covers that role) composed into one `shell.qml`, useful as an
  end-state completeness check for the modules actually being built.

Recommended: clone one locally and run it standalone (Quickshell supports
running a config by path) to see the IPC patterns working, before writing
`services/` from scratch.
