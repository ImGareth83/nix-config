# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix`: Flake entrypoint defining inputs and macOS (nix-darwin) + Home Manager outputs.
- `home.nix`: Home Manager configuration for user-level settings and module imports.
- `homebrew.nix`: Homebrew-related nix-darwin configuration.
- `modules/`: Modular Nix configs (packages, shell, programs, neovim, dotfiles).
- `secrets/`: Local-only inputs consumed by the flake (keep private, no secrets in commits).

## Build, Test, and Development Commands
- `darwin-rebuild build --flake .#mbp`: Build the system closure without switching (dry run).
- `darwin-rebuild switch --flake .#mbp`: Build and activate nix-darwin + Home Manager config.
- `home-manager switch --flake .#gareth@mbp`: Apply only Home Manager changes.
- `nix flake update`: Update pinned inputs; follow with a rebuild.
- `darwin-rebuild switch --rollback --flake .#mbp`: Roll back to the previous generation.

## Coding Style & Naming Conventions
- Nix files use 2-space indentation and consistent brace alignment; follow existing file style.
- Keep module boundaries clean: add new config in `modules/` when it’s reusable.
- Prefer explicit, descriptive option names; keep comments short and purposeful.
- No project-wide formatter is configured; keep formatting consistent with adjacent code.

## Testing Guidelines
- There is no automated test suite in this repo.
- Validate changes by building or switching:
  - `darwin-rebuild build --flake .#mbp` for a safe validation pass.
  - `darwin-rebuild switch --flake .#mbp` when you’re ready to apply.

## Commit & Pull Request Guidelines
- Commit messages in history are short, imperative, and descriptive (e.g., “Add zsh aliases…”).
- Keep commits focused on a single change area (e.g., Home Manager, Homebrew, a module).
- PRs (if used) should include a short description, commands run, and any host-specific notes.

## Security & Configuration Tips
- Treat `secrets/` as local-only: do not commit sensitive values.
- When changing system defaults or activation scripts, note any required manual steps.
