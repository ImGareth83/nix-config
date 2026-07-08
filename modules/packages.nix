{ pkgs, lib, inputs, ... }:

let
  # Feature flags - easily toggle package groups
  enableDevTools = true;
  enableCloudTools = true;
  enableGUIApps = pkgs.stdenv.isDarwin;  # Only on macOS
  awsPkgs = import inputs.nixpkgs-awscli {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # ============================================================================
  # User packages
  # ============================================================================
  home.packages = with pkgs; [
    (writeShellScriptBin "gstate" ''
      echo '-state-'
      git status -sb
      echo '-staged-'
      git diff --staged
      echo '-main-'
      git diff main
      echo '-log-'
      git log --oneline -5
    '')
    (writeShellScriptBin "ll" ''
      exec ls --color=auto --group-directories-first -golah "$@"
    '')
    (writeShellScriptBin "eza" ''
      exec ${pkgs.eza}/bin/eza --tree --level=1 --group-directories-first -a . "$@"
    '')

    # Fonts (Nerd Font for terminal/Neovim icons)
    meslo-lgs-nf

    # CLI utilities (always included)
    bat        # prettier `cat`
    coreutils  # GNU tools, including `gls` for `ls --color`
    fd         # simpler `find`
    git
    jaq
    jq
    ripgrep
    postgresql
    tree-sitter
    pandoc
    tldr
    tmux
    tree
    
    # Zsh plugins (always included)
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
  ]
  # Cloud/DevOps tools (conditional)
  ++ lib.optionals enableCloudTools [
    (awsPkgs.awscli2.overridePythonAttrs (old: rec {
      version = "2.35.0";
      src = awsPkgs.fetchFromGitHub {
        owner = "aws";
        repo = "aws-cli";
        tag = version;
        hash = "sha256-EZpCmwPe84rtWDjceTVOyKyrDgC6ae83aWnKDnwPnjM=";
      };
      postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail 'flit_core>=3.7.1,<3.12.1' 'flit_core>=3.7.1' \
          --replace-fail 'awscrt==' 'awscrt>=' \
          --replace-fail 'distro>=1.5.0,<1.9.0' 'distro>=1.5.0' \
          --replace-fail 'docutils>=0.10,<0.20' 'docutils>=0.10' \
          --replace-fail 'jmespath>=0.7.1,<1.1.0' 'jmespath>=0.7.1' \
          --replace-fail 'prompt-toolkit>=3.0.24,<3.0.52' 'prompt-toolkit>=3.0.24' \
          --replace-fail 'ruamel_yaml>=0.15.0,<=0.19.1' 'ruamel_yaml>=0.15.0' \
          --replace-fail 'ruamel_yaml_clib>=0.2.0,<=0.2.15' 'ruamel_yaml_clib>=0.2.0' \
          --replace-fail 'wcwidth<0.3.0' 'wcwidth>=0.3.0'

        substituteInPlace requirements-base.txt \
          --replace-fail "wheel==0.46.3" "wheel>=0.46.3"

        # Upstream validates pip at build time, but Nix supplies dependencies.
        sed -i '/pip>=/d' requirements/bootstrap.txt
      '';
    }))
    kubectl
    argocd
    tilt
  ]
  # Development tools (conditional)
  ++ lib.optionals enableDevTools [
    nodejs_22
    zx
    pnpm
    uv
    python310
    python313Packages.markitdown
    go
    jdk21
    gradle
    maven
  ]
  # GUI Applications (only on macOS)
  ++ lib.optionals enableGUIApps [
    dbeaver-bin
    code-cursor  # Package name is code-cursor, but executable is 'cursor'
    vscode
    jiratui
    pgadmin4-desktopmode
  ];
}
