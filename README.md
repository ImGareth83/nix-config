Gareth's nix-darwin config
===========================

This repo contains a flake-based `nix-darwin` + Home Manager configuration for macOS (host `mbp`).

## Prerequisites

- **Nix** installed (with flakes enabled).
- **nix-darwin** installed (provides the `darwin-rebuild` command).

## Rebuild and activate the system (including Home Manager)

From the root of this repo:

1. **Build only (dry run of the system closure):**

   ```bash
   darwin-rebuild build --flake .#mbp
   ```

2. **Build and activate the configuration (system + Home Manager):**

   ```bash
   darwin-rebuild switch --flake .#mbp
   ```

   This will:

   - Apply the `nix-darwin` system configuration for host `mbp`.
   - Run the integrated Home Manager configuration defined in `home.nix`.

   With this setup, Home Manager is normally activated as part of `darwin-rebuild switch`.

## Apply only Home Manager (user-level) changes

If you have made **pure Home Manager / user-level changes** (e.g. shell, editor, dotfiles) and do **not** want to rebuild the whole system, you can activate just the Home Manager part:

```bash
home-manager switch --flake .#gareth@mbp
```

This assumes your Home Manager configuration is exported under the `gareth@mbp` user profile in the flake (matching `home.username = "gareth";` and host `mbp`).

## Updating inputs (nixpkgs, home-manager, etc.)

To update flake inputs and then rebuild:

```bash
nix flake update
darwin-rebuild switch --flake .#mbp
```

## Common troubleshooting

- **Rollback to previous generation:**

  ```bash
  darwin-rebuild switch --rollback --flake .#mbp
  ```

- **Garbage collect old Nix store paths (optional cleanup):**

  ```bash
  nix-collect-garbage -d
  ```

