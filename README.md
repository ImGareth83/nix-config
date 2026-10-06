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
   sudo darwin-rebuild switch --flake .#mbp
   ```

   Use this as the default command whenever you want to rebuild and apply the full nix-darwin system.

   This will:

   - Apply the `nix-darwin` system configuration for host `mbp`.
   - Run the integrated Home Manager configuration defined in `home.nix`.

   With this setup, Home Manager is normally activated as part of `darwin-rebuild switch`.

## Apply only Home Manager (user-level) changes

If you have made **pure Home Manager / user-level changes** (e.g. shell, editor, dotfiles) and do **not** want to rebuild the whole system, use this command:

```bash
home-manager switch --flake .#gareth
```

This is the default command for Home Manager-only changes. It assumes your Home Manager configuration is exported under the `gareth` profile in the flake (matching `home.username = "gareth";`).

## Azure CLI profiles

Use `az-symphony` for symphonyda.io and `az-phillip` for phillip.com.sg.
Each command keeps its login, selected subscription, and configuration in a
separate directory (`~/.azure-symphony` and `~/.azure-phillip`).

After applying the configuration, sign in to each organization:

```bash
az-symphony login
az-phillip login
```

Choose the matching organization's account during each login. If needed, pass
`--tenant <tenant-id>` to select its Microsoft Entra tenant explicitly.

Check or select a subscription independently for each profile:

```bash
az-symphony account show
az-phillip account show
az-symphony account set --subscription <subscription-id>
az-phillip account set --subscription <subscription-id>
```

Use the profile command in place of `az` for subsequent operations. Plain `az`
continues to use its default configuration; these wrappers do not change the
calling shell's environment.

## Updating inputs (nixpkgs, home-manager, etc.)

To update flake inputs and then rebuild:

```bash
nix flake update
sudo darwin-rebuild switch --flake .#mbp
```

## Common troubleshooting

- **Rollback to previous generation:**

  ```bash
  sudo darwin-rebuild switch --rollback --flake .#mbp
  ```

- **Garbage collect old Nix store paths (optional cleanup):**

  ```bash
  nix-collect-garbage -d
  ```
