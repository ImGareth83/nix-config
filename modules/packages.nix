{ pkgs, lib, ... }:

let
  # Feature flags - easily toggle package groups
  enableDevTools = true;
  enableCloudTools = true;
  enableGUIApps = pkgs.stdenv.isDarwin;  # Only on macOS
in
{
  # ============================================================================
  # User packages
  # ============================================================================
  home.packages = with pkgs; [
    (writeShellScriptBin "gstate" ''
      echo '-state-'
      git status -sb
      echo '-staged-'
      git diff --staged
      echo '-main-'
      git diff main
      echo '-log-'
      git log --oneline -5
    '')
    (writeShellScriptBin "ll" ''
      exec ls --color=auto --group-directories-first -golah "$@"
    '')
    (writeShellScriptBin "eza" ''
      exec ${pkgs.eza}/bin/eza --tree --level=1 --group-directories-first -a . "$@"
    '')

    # Fonts (Nerd Font for terminal/Neovim icons)
    meslo-lgs-nf

    # CLI utilities (always included)
    bat        # prettier `cat`
    coreutils  # GNU tools, including `gls` for `ls --color`
    fd         # simpler `find`
    git
    glab
    jq
    ripgrep
    tree-sitter
    pandoc
    tldr
    tmux
    tree
    
    # Zsh plugins (always included)
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
  ]
  # Cloud/DevOps tools (conditional)
  ++ lib.optionals enableCloudTools [
    awscli2
    kubectl
    argocd
  ]
  # Development tools (conditional)
  ++ lib.optionals enableDevTools [
    nodejs_22
    pnpm
    uv
    python310
    python313Packages.markitdown
    go
    jdk21
    gradle
    maven
  ]
  # GUI Applications (only on macOS)
  ++ lib.optionals enableGUIApps [
    dbeaver-bin
    code-cursor  # Package name is code-cursor, but executable is 'cursor'
    vscode
    jiratui
    pgadmin4-desktopmode
  ];
}
