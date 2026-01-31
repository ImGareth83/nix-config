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
        gs = "status -sb";
        gd = "diff";
        gds = "diff --staged";
        gl = "log --oneline --graph --decorate -n 20";
        gll = "log --stat -n 10";
        gshow = "show --stat";
        gwt = "worktree list";
        gbr = "branch -vv";
        gtag = "tag -n";
        gb = "branch";
        gba = "branch -a";
        gbd = "branch -d";
        gbD = "branch -D";
        gsw = "switch";
        gsc = "switch -c";
        gco = "checkout";
        ga = "add -A";
        gcm = "commit -m";
        gca = "commit --amend";
        grs = "reset --soft HEAD~1";
        gpl = "pull --rebase";
        gfa = "fetch --all --prune";
        gpu = "push -u origin HEAD";
      };
    };
  };
}
