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
      nvim-lspconfig
      nvim-web-devicons
      flash-nvim
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
          ensure_installed = { 'markdown', 'markdown_inline', 'sql' },
          highlight = { enable = true },
          auto_install = true,
        })
      end

      if type(vim.lsp) == 'table'
        and type(vim.lsp.config) == 'function'
        and type(vim.lsp.enable) == 'function'
      then
        if vim.fn.executable('sqls') == 1 then
          vim.lsp.config('sqls', {
            cmd = { 'sqls' },
            filetypes = { 'sql' },
          })
          vim.lsp.enable('sqls')
        end

        local postgres_cmd_candidates = {
          'postgres_lsp',
          'postgres-lsp',
          'postgres-language-server',
          'postgrestools',
        }
        local postgres_cmd = nil
        for _, candidate in ipairs(postgres_cmd_candidates) do
          if vim.fn.executable(candidate) == 1 then
            postgres_cmd = candidate
            break
          end
        end

        if postgres_cmd then
          vim.lsp.config('postgres_lsp', {
            cmd = { postgres_cmd },
            filetypes = { 'postgres', 'pgsql' },
          })
          vim.lsp.enable('postgres_lsp')
        end
      end

      local ok_rm, render_md = pcall(require, 'render-markdown')
      if ok_rm and render_md then
        render_md.setup({})
      end

      local ok_flash, flash = pcall(require, 'flash')
      if ok_flash and flash then
        flash.setup({})
        vim.keymap.set({ 'n', 'x', 'o' }, 's', function() flash.jump() end, { desc = 'Flash' })
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() flash.treesitter() end, { desc = 'Flash Treesitter' })
        vim.keymap.set('o', 'r', function() flash.remote() end, { desc = 'Remote Flash' })
        vim.keymap.set({ 'o', 'x' }, 'R', function() flash.treesitter_search() end, { desc = 'Treesitter Search' })
        vim.keymap.set('c', '<c-s>', function() flash.toggle() end, { desc = 'Toggle Flash Search' })
      end
    '';
  };
}
