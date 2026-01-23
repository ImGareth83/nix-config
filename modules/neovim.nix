{ ... }:

{
  # ============================================================================
  # Neovim Configuration
  # ============================================================================
  programs.neovim = {
    enable = true;
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
  };
}
