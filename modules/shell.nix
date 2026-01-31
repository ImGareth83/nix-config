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
      "~" = "cd ~";
      workspace = "cd /Users/gareth";
    };
    # Use initContent instead of deprecated initExtra
    initContent = ''
      export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      
      # CASE-INSENSITIVE AUTOCOMPLETE
      autoload -Uz compinit && compinit
      zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
      
      # Eclipse-style directory navigation (move up directories)
      # Usage: type ".." to go up one directory, "..." to go up two, etc.
      ..() { builtin cd ..; }
      ...() { builtin cd ../..; }
      ....() { builtin cd ../../..; }
      .....() { builtin cd ../../../..; }
      
     # echo "[ZSH INIT] Loaded by Home Manager"
    '';
  };
}
