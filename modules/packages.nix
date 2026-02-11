{ pkgs, lib, ... }:

let
  # Feature flags - easily toggle package groups
  enableDevTools = true;
  enableCloudTools = true;
  enableGUIApps = pkgs.stdenv.isDarwin;  # Only on macOS
  postgresLspPackage =
    if builtins.hasAttr "postgres-language-server" pkgs then pkgs."postgres-language-server"
    else if builtins.hasAttr "postgres-lsp" pkgs then pkgs."postgres-lsp"
    else if builtins.hasAttr "postgresql-lsp" pkgs then pkgs."postgresql-lsp"
    else null;
in
{
  # ============================================================================
  # User packages
  # ============================================================================
  home.packages = with pkgs; [
    # Fonts (Nerd Font for terminal/Neovim icons)
    meslo-lgs-nf

    # CLI utilities (always included)
    bat        # prettier `cat`
    fd         # simpler `find`
    git
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
  ++ lib.optionals enableDevTools (
    [
      nodejs_22
      pnpm
      jdk21
      gradle
      maven
      sqls
    ]
    ++ lib.optionals (postgresLspPackage != null) [ postgresLspPackage ]
  )
  # GUI Applications (only on macOS)
  ++ lib.optionals enableGUIApps [
    dbeaver-bin
    code-cursor  # Package name is code-cursor, but executable is 'cursor'
    vscode
    jiratui
    pgadmin4
  ];
}
