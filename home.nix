{ pkgs, lib, inputs, ... }:

{
  home.username = "gareth";
  home.homeDirectory = "/Users/gareth";
  home.stateVersion = "24.05"; # Match your nixpkgs version


  # CLI tools (user-scoped)
  home.packages = with pkgs; [
    bat        # prettier `cat`
    fd         # simpler `find`
    git
    jq
    tmux
    tree
    zsh-autosuggestions
    zsh-syntax-highlighting
    awscli2
    kubectl
    argocd
    dbeaver-bin
    nodejs_22
    pnpm
    code-cursor
    jdk21
    gradle
    maven
    vscode
    jiratui
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    JAVA_HOME = "${pkgs.jdk21}";
  };


  home.activation.finderDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "🔧 Applying custom Finder settings..."

    # Show hidden files
    /usr/bin/defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show path bar
    /usr/bin/defaults write com.apple.finder ShowPathbar -bool true

    # Show status bar
    /usr/bin/defaults write com.apple.finder ShowStatusBar -bool true

    # List view by default
    /usr/bin/defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Show POSIX path in title
    /usr/bin/defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Expand save panel by default
    /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Disable extension change warning
    /usr/bin/defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Disable .DS_Store on network volumes
    /usr/bin/defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Relaunch Finder to apply
    /usr/bin/killall Finder || true
  '';


  home.file.".aws/config" = {
    source = inputs.secrets + "/aws/config";
  };

  home.file.".aws/credentials" = { 
    source = inputs.secrets + "/aws/credentials";
  };


  # Shell configuration (Zsh)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "/Users/gareth"; # So config goes to ~/.zshrc, not ~/.config/zsh/.zshrc
    shellAliases = {
      k = "kubectl";
      a = "argocd";
    };
    #initExtra = ''
    initContent = ''
      export PATH="$HOME/bin:$PATH"
      alias ll="ls -golah"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
     # echo "[ZSH INIT] Loaded by Home Manager"
    '';

  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Gareth Fong";
        email = "garethfong@icloud.com";
      };
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        lg = "log --oneline --decorate --graph --all";
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set et
      set ts=2
      set sw=2
      set sts=2
      set si
      set ic
      set bg=dark
      set nu
      set cursorline
      set cursorcolumn
      highlight CursorLine ctermbg=darkgrey guibg=#333333
      highlight CursorColumn ctermbg=darkgrey guibg=#333333
    '';
  };

  # Dotfiles
  home.file.".vimrc".text = ''
    set number
    syntax on
    set tabstop=2 shiftwidth=2 expandtab
  '';

  home.file.".tmux.conf".text = ''
    set -g mouse on
    set -g history-limit 10000
    setw -g mode-keys vi
  '';
}

