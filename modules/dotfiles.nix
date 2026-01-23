{ config, ... }:

{
  # ============================================================================
  # Dotfiles Management
  # ============================================================================
  home.file.".aws/config" = {
    source = config._module.args.inputs.secrets + "/aws/config";
  };

  home.file.".aws/credentials" = { 
    source = config._module.args.inputs.secrets + "/aws/credentials";
  };

  # ============================================================================
  # Additional Dotfiles
  # ============================================================================
  home.file.".vimrc".text = ''
    set number
    syntax on
    set tabstop=2 shiftwidth=2 expandtab
  '';

  home.file.".tmux.conf".text = ''
    set -g mouse on
    set -g history-limit 10000
    setw -g mode-keys vi
    set -g set-clipboard on
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "/usr/bin/pbcopy"
  '';
}
