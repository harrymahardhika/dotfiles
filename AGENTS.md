# Repository Guidelines

## Project Structure & Module Organization
- `nvim-configs/<profile>/` hosts self-contained Neovim configurations; keep shared helpers under each profile's `lua/` tree and document new modules in that profile's README when needed.
- `nvim-configs/stylua.toml` defines the Lua formatter baselines used across all profiles.
- `scripts/` collects shell utilities for desktop automation; wrappers in `scripts/app/` launch specific web apps, while top-level scripts manage tooling (`changelog.sh`, `nvim-switch.sh`, etc.).
- `updateall` is a standalone maintenance script; adjust distro-specific branches carefully and test both the Arch and Debian paths when editing it.
- `wallpapers/` stores static assets referenced by compositor and theming scripts; keep filenames descriptive and prefer lossless formats for new additions.

## Build, Test, and Development Commands
- Run `./scripts/nvim-switch.sh` to symlink a profile from `nvim-configs/` into `~/.config/nvim`; use this before exercising a new configuration.
- Use `./scripts/changelog.sh 14` to review recent Git activity (override the day window as needed) and validate release notes.
- Execute `./updateall` on a test machine after modifying package-management logic to ensure both branches succeed without prompts.

## Coding Style & Naming Conventions
- Lua: two-space indentation, snake_case module names, and explicit `require` paths; format via `stylua --config-path nvim-configs/stylua.toml <files>` before committing.
- Shell: target Bash, keep functions snake_case, follow the existing single-bracket conditional style, and match the indentation used in the touched file (most scripts use two spaces); run `chmod +x` on new executables.
- Script filenames should describe the action (e.g., `battery_limit.sh`) and live alongside related tooling.

## Testing Guidelines
- For shell changes, run `bash -n <script>` and, when available, `shellcheck <script>` to catch lint issues; smoke-test commands directly.
- For Neovim profiles, switch via `./scripts/nvim-switch.sh`, open Neovim, and run `:checkhealth` plus any relevant plugin commands to confirm startup without errors.
- Document manual test steps in the pull request when automation is not feasible.

## Commit & Pull Request Guidelines
- Follow the existing conventional style (`feat(scope): summary`, `fix`, `refactor`, etc.); include a short body explaining why complex changes were made.
- Group related edits per commit, avoid mixing personal environment tweaks with shared scripts, and ensure executable mode bits are correct in Git.
- Pull requests should outline the change, list validation steps, mention related issues, and include screenshots or terminal captures when adjusting visuals or UX scripts.
