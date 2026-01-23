{ pkgs, ... }:

{
  # ============================================================================
  # User packages
  # ============================================================================
  home.packages = with pkgs; [
    # CLI utilities
    bat        # prettier `cat`
    fd         # simpler `find`
    git
    jq
    tmux
    tree
    
    # Zsh plugins
    zsh-autosuggestions
    zsh-syntax-highlighting
    
    # Cloud/DevOps tools
    awscli2
    kubectl
    argocd
    
    # Development tools
    nodejs_22
    pnpm
    jdk21
    gradle
    maven
    
    # Applications
    dbeaver-bin
    code-cursor
    vscode
    jiratui
  ];
}
