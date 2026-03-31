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
      ls = "ls --color=auto";
      ll = "ls --color=auto -golah";  # Moved from initContent to shellAliases (proper location)
      "~" = "cd ~";
      workspace = "cd /Users/gareth/workspace";
      phillip = "cd /Users/gareth/workspace/phillip";
      learn = "cd /Users/gareth/workspace/learn";
    };
    # Use initContent instead of deprecated initExtra
    initContent = ''
      export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:/Library/TeX/texbin:$PATH"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh
      
      # CASE-INSENSITIVE AUTOCOMPLETE
      zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"

      # Keybindings
      bindkey "^]" backward-kill-line
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[5D" backward-word
      bindkey "^[[5C" forward-word
      
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
