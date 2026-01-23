{ ... }:

{
  # ============================================================================
  # Git Configuration
  # ============================================================================
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Gareth Fong";
        email = "garethfong@icloud.com";
      };
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        lg = "log --oneline --decorate --graph --all";
      };
    };
  };
}
