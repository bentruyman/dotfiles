# Repository Guidelines

## Project Structure & Module Organization
- `bootstrap.sh` downloads the repo and hands off to `setup.sh`; keep both idempotent so first-run machines succeed.
- `setup.sh` provisions macOS by linking `bin/`, `config/`, `launch_agents/`, and root dotfiles, installing Homebrew bundles, and tuning defaults. Document any new prerequisites inline.
- `bin/` contains small CLI helpers added to `$PATH`; prefer self-contained scripts with clear error handling.
- `config/` mirrors `~/.config` (e.g., `config/fish`, `config/nvim`); only add directories that can be safely symlinked.
- `launch_agents/` holds launchd plists loaded into `~/Library/LaunchAgents`; keep labels unique and unload obsolete jobs when replacing them.
- `Brewfile` and `Brewfile.lock.json` pin formulae/casks; regenerate the lockfile with `brew bundle lock --file=Brewfile` after changes.

## Build, Test, and Development Commands
- `./bootstrap.sh` — fetches and bootstraps dotfiles. Test in isolation with `DOTFILES_DIR=/tmp/dotfiles ./bootstrap.sh`.
- `./setup.sh` — full provisioning run (requires sudo and tweaks system defaults); review the script diff before executing on your primary machine.
- `brew bundle check --file=Brewfile` — validates Homebrew dependencies.
- `shellcheck bin/* setup.sh` — lint Bash scripts.
- `fish_indent -w config/fish/**/*.fish` — format Fish shell updates.

## Coding Style & Naming Conventions
- Bash scripts use `#!/usr/bin/env bash`, `set -euo pipefail`, two-space indentation, quoted variables, and `[[` conditions.
- Fish functions live in `config/fish`; keep filenames kebab-cased and run `fish_indent`.
- Launch agent files follow `com.bentruyman.<purpose>.plist` and should include descriptive `ProgramArguments`.

## Testing Guidelines
- Record manual verification steps for provisioning changes (e.g., `launchctl list | grep com.bentruyman`).
- Script updates should include example usage (inline or in docs) or a lightweight `bats` test when practical.
- After editing Homebrew or CLI helpers, run `brew bundle check` and execute the modified command in a clean shell.

## Commit & Pull Request Guidelines
- History follows Conventional Commits (`feat:`, `fix:`, `chore:`); `chore: checkpoint` is used for snapshots. Match that voice and sign commits (GPG is configured).
- Squash fixups before pushing. PRs must describe motivation, call out machine-impacting changes, and list manual test evidence or screenshots for UI tweaks (e.g., Ghostty themes).

## Security & Secrets
- Never commit personal tokens, SSH keys, or machine-specific secrets; keep overrides in `~/.dotfiles/local`, which is ignored.
- Review new scripts for outbound network calls and document any required environment variables or secret management steps.
