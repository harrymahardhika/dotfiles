# Pi — Global Agent Instructions

- Per-project rules are loaded automatically from each project's `AGENTS.md` /
  `CLAUDE.md` (e.g. `~/dotfiles/AGENTS.md`). Follow those first when working
  inside a repository.
- Use the standard four tools (`read`, `write`, `edit`, `bash`) to get work
  done; use `git` as a checkpoint before risky or bulk edits.
- Keep responses concise and actionable; confirm before destructive operations.
- In `~/dotfiles`, respect the GNU Stow / symlink workflow and the conventions
  documented in the repo `AGENTS.md`. Config edits are live immediately — no
  re-stow needed.
