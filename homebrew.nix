{ pkgs, ... }:

{
  # ============================================================================
  # Homebrew Configuration
  # ============================================================================
  homebrew = {
    enable = true;
    # nix-darwin runs `brew bundle` via its own activation script, so
    # Home Manager session variables do not control this path.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    masApps = {
      "Amphetamine" = 937984704;
      "Whatsapp" = 310633997;
      "Wechat" = 836500024;
      "Telegram" = 747648890;
      "moomoo" = 1482713641;
      "Slack" = 803453959;
      "Magnet" = 441258766;
      "cleanmykeyboard" = 6468120888;
    };

    brews = [
      "watch"
      "openssl"
      "mas"
      "bitwarden-cli"
      "glab"
      "hashicorp/tap/terraform"
    ];
    
    casks = [
      "battery"
      "brave-browser"
      "claude"
      "claude-code"
      "codex"
      "chatgpt"
      "itsycal"
      "drawio"
      "maccy"
      "mactex"
    ];
      
    taps = [
      "hashicorp/tap"
      # "homebrew/cask-fonts"
    ];
  };
}
