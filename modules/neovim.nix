{ pkgs, lib, ... }:

let
  postgresLspPackage =
    if builtins.hasAttr "postgres-language-server" pkgs then pkgs."postgres-language-server"
    else if builtins.hasAttr "postgres-lsp" pkgs then pkgs."postgres-lsp"
    else if builtins.hasAttr "postgresql-lsp" pkgs then pkgs."postgresql-lsp"
    else null;
in
{
  # ============================================================================
  # Neovim Configuration
  # ============================================================================
  programs.nixvim = {
    enable = true;

    opts = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      smartindent = true;
      ignorecase = true;
      clipboard = "unnamedplus";
      background = "dark";
      number = true;
      relativenumber = true;
      cursorline = true;
      cursorcolumn = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      render-markdown-nvim
    ];

    extraPackages =
      [ pkgs.sqls ]
      ++ lib.optionals (postgresLspPackage != null) [ postgresLspPackage ];

    plugins = {
      flash.enable = true;

      lsp.enable = true;

      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [ "markdown" "markdown_inline" "sql" ];
          highlight.enable = true;
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg = 'darkgrey', bg = '#333333' })
      vim.api.nvim_set_hl(0, 'CursorColumn', { ctermbg = 'darkgrey', bg = '#333333' })

      if type(vim.lsp) == 'table'
        and vim.lsp.config ~= nil
        and type(vim.lsp.enable) == 'function'
      then
        if vim.fn.executable('sqls') == 1 then
          vim.lsp.config('sqls', {
            cmd = { 'sqls' },
            filetypes = { 'sql' },
          })
          vim.lsp.enable('sqls')
        end

        local postgres_cmd = nil
        if vim.fn.executable('postgres-language-server') == 1 then
          postgres_cmd = { 'postgres-language-server', 'lsp-proxy' }
        elseif vim.fn.executable('postgres_lsp') == 1 then
          postgres_cmd = { 'postgres_lsp' }
        elseif vim.fn.executable('postgres-lsp') == 1 then
          postgres_cmd = { 'postgres-lsp' }
        end

        if postgres_cmd ~= nil then
          vim.lsp.config('postgres_lsp', {
            cmd = postgres_cmd,
            filetypes = { 'sql', 'postgres', 'pgsql' },
            workspace_required = false,
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
        vim.keymap.set({ 'n', 'x', 'o' }, 's', function() flash.jump() end, { desc = 'Flash' })
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() flash.treesitter() end, { desc = 'Flash Treesitter' })
        vim.keymap.set('o', 'r', function() flash.remote() end, { desc = 'Remote Flash' })
        vim.keymap.set({ 'o', 'x' }, 'R', function() flash.treesitter_search() end, { desc = 'Treesitter Search' })
        vim.keymap.set('c', '<c-s>', function() flash.toggle() end, { desc = 'Toggle Flash Search' })
      end
    '';
  };
}
