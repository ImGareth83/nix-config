{ pkgs, ... }:

{
  # ============================================================================
  # Homebrew Configuration
  # ============================================================================
  homebrew = {
    enable = true;
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
    };

    brews = [
      "watch"
      "openssl"
      "mas"
      "bitwarden-cli"
    ];
    
    casks = [
      "brave-browser"
      "chatgpt"
      "itsycal"
      "drawio"
      "maccy"
    ];
      
    #taps = [
      # "homebrew/cask-fonts"
    #];
  };
}
