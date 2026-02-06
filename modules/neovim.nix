{ pkgs, ... }:

let
  # render-markdown.nvim: not in nixpkgs, build from GitHub
  render-markdown-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "render-markdown-nvim";
    version = "2024-12-20";
    src = pkgs.fetchFromGitHub {
      owner = "MeanderingProgrammer";
      repo = "render-markdown.nvim";
      rev = "48b4175dbca8439d30c1f52231cbe5a712c8f9d9";
      hash = "sha256-NJeCT4oEKNwkX3Go1l54jTNExb9CFdrAlcYVcdc6Bfo=";
    };
  };
in
{
  # ============================================================================
  # Neovim Configuration
  # ============================================================================
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-web-devicons
      render-markdown-nvim
    ];

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

    extraLuaConfig = ''
      -- Only run if Nix-installed plugins are on rtp (i.e. using Nix-managed nvim)
      local ok_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
      if ok_ts and ts_configs then
        ts_configs.setup({
          ensure_installed = { 'markdown', 'markdown_inline' },
          highlight = { enable = true },
          auto_install = true,
        })
      end

      local ok_rm, render_md = pcall(require, 'render-markdown')
      if ok_rm and render_md then
        render_md.setup({})
      end
    '';
  };
}
