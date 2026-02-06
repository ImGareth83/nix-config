{ pkgs, lib, inputs, config, ... }:

{
  # ============================================================================
  # Basic Configuration
  # ============================================================================
  home.username = "gareth";
  home.homeDirectory = "/Users/gareth";
  home.stateVersion = "24.05"; # Match your nixpkgs version

  # ============================================================================
  # Environment Variables
  # ============================================================================
  home.sessionVariables = {
    EDITOR = "nvim";
    JAVA_HOME = "${pkgs.jdk21}";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    HOMEBREW_AUTO_UPDATE_SECS = "86400"; # once per day
    PATH = "/Library/TeX/texbin:$PATH";
  };

  # ============================================================================
  # Activation Scripts
  # ============================================================================
  # Install Nerd Fonts (and other profile fonts) into ~/Library/Fonts on macOS
  home.activation.installFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "$HOME/.nix-profile/share/fonts" ]; then
      echo "🔤 Installing fonts to ~/Library/Fonts..."
      find "$HOME/.nix-profile/share/fonts" -type f \( -name "*.otf" -o -name "*.ttf" \) -exec ln -sfn {} "$HOME/Library/Fonts/" \;
    fi
  '';

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

  # ============================================================================
  # Module Arguments
  # ============================================================================
  # Pass inputs to imported modules via _module.args
  _module.args.inputs = inputs;

  # ============================================================================
  # Module Imports
  # ============================================================================
  imports = [
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/programs.nix
    ./modules/neovim.nix
    ./modules/dotfiles.nix
  ];
}
