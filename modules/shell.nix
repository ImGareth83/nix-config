{ pkgs, config, ... }:

{
  # ============================================================================
  # Shell configuration (Zsh)
  # ============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Use absolute path constructed from homeDirectory to avoid deprecation warning
    dotDir = "${config.home.homeDirectory}"; # So config goes to ~/.zshrc, not ~/.config/zsh/.zshrc
    shellAliases = {
      k = "kubectl";
      a = "argocd";
      ll = "ls -golah";  # Moved from initContent to shellAliases (proper location)
    };
    # Use initContent instead of deprecated initExtra
    initContent = ''
      export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
     # echo "[ZSH INIT] Loaded by Home Manager"
    '';
  };
}
