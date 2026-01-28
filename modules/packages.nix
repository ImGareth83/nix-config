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
    # CLI utilities (always included)
    bat        # prettier `cat`
    fd         # simpler `find`
    git
    jq
    pandoc
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
    jdk21
    gradle
    maven
    codex
  ]
  # GUI Applications (only on macOS)
  ++ lib.optionals enableGUIApps [
    dbeaver-bin
    code-cursor  # Package name is code-cursor, but executable is 'cursor'
    vscode
    jiratui
  ];
}
