{ lib, pkgs, ... }:

let
  homebrewTrust = builtins.toJSON {
    trustedformulae = [
      "atlassian/acli/acli"
      "hashicorp/tap/terraform"
    ];
    trustedtaps = [
      "atlassian/acli"
      "hashicorp/tap"
      "xykong/tap"
    ];
    trustedcasks = [
      "xykong/tap/flux-markdown"
    ];
  };
in {
  # ============================================================================
  # Homebrew Configuration
  # ============================================================================
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  # nix-darwin runs Homebrew activation before Home Manager and without
  # XDG_CONFIG_HOME, so seed Homebrew's default trust path first.
  system.activationScripts.preActivation.text = lib.mkAfter ''
    install -d -m 700 -o gareth -g staff /Users/gareth/.homebrew
    cat > /Users/gareth/.homebrew/trust.json <<'EOF'
    ${homebrewTrust}
    EOF
    chown gareth:staff /Users/gareth/.homebrew/trust.json
    chmod 600 /Users/gareth/.homebrew/trust.json
  '';

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
      "atlassian/homebrew-acli/acli"
      "watch"
      "openssl"
      "python"
      "mas"
      "bitwarden-cli"
      "glab"
      "poppler"
      "rtk"
      "hashicorp/tap/terraform"
    ];
    
    casks = [
      "battery"
      "brave-browser"
      "claude"
      "claude-code@latest"
      "codex"
      "chatgpt"
      "xykong/tap/flux-markdown"
      "itsycal"
      "drawio"
      "maccy"
      "mactex"
    ];
      
    taps = [
      "atlassian/homebrew-acli"
      "hashicorp/tap"
      "xykong/tap"
      # "homebrew/cask-fonts"
    ];
  };
}
