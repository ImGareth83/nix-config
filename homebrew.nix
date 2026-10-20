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
      "sametkum/klustr"
      "xykong/tap"
    ];
    trustedcasks = [
      "sametkum/klustr/klustr"
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
    trust_tmp=$(mktemp /Users/gareth/.homebrew/trust.json.XXXXXX)
    cat > "$trust_tmp" <<'EOF'
    ${homebrewTrust}
    EOF
    chown gareth:staff "$trust_tmp"
    chmod 600 "$trust_tmp"
    mv -f "$trust_tmp" /Users/gareth/.homebrew/trust.json
  '';

  # Explicitly upgrade Codex after Homebrew processes the declared casks.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ -x /opt/homebrew/bin/brew ]; then
      echo "Upgrading Codex..." >&2
      sudo --user=gareth --set-home \
        /opt/homebrew/bin/brew upgrade --cask codex
    fi
  '';

  homebrew = {
    enable = true;
    # nix-darwin runs `brew bundle` via its own activation script, so
    # Home Manager session variables do not control this path.
    onActivation.autoUpdate = true;
    # Upgrade declared Homebrew packages and App Store apps on activation.
    onActivation.upgrade = true;

    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Xcode" = 497799835;
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
      "bleunlock"
      "brave-browser"
      "chatgpt"
      "claude"
      "claude-code@latest"
      "codex"
      "xykong/tap/flux-markdown"
      "itsycal"
      "sametkum/klustr/klustr"
      "drawio"
      "maccy"
      "mactex"
      "session-manager-plugin"
    ];
      
    taps = [
      "atlassian/homebrew-acli"
      "hashicorp/tap"
      "sametkum/klustr"
      "xykong/tap"
      # "homebrew/cask-fonts"
    ];
  };
}
