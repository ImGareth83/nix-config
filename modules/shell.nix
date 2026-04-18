{ pkgs, config, ... }:

{
  # ============================================================================
  # Shell configuration (Zsh)
  # ============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Use absolute path constructed from homeDirectory to avoid deprecation warning
    dotDir = "${config.home.homeDirectory}"; # So config goes to ~/.zshrc, not ~/.config/zsh/.zshrc
    shellAliases = {
      k = "kubectl";
      a = "argocd";
      md = "markitdown";
      gstate = "echo '-state-' && git status -sb && echo '-staged-' && git diff --staged && echo '-main-' && git diff main && echo '-log-'&& git log --oneline -5";
      ls = "ls --color=auto --group-directories-first";
      ll = "ls --color=auto --group-directories-first -golah";
      "~" = "cd ~";
      workspace = "cd /Users/gareth/workspace";
      phillip = "cd /Users/gareth/workspace/phillip";
      learn = "cd /Users/gareth/workspace/learn";
    };
    # Use initContent instead of deprecated initExtra
    initContent = ''
      export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:/Library/TeX/texbin:$PATH"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh

      if [ -f "$HOME/nix/secrets/gitlab/token" ]; then
        export GITLAB_TOKEN="$(tr -d '\r\n' < "$HOME/nix/secrets/gitlab/token")"
      fi

      if [ -f "$HOME/nix/secrets/atlassian/token" ]; then
        export ATLASSIAN_TOKEN="$(tr -d '\r\n' < "$HOME/nix/secrets/atlassian/token")"
      fi

      if command -v acli >/dev/null 2>&1; then
        eval "$(acli completion zsh)"
      fi

      if command -v glab >/dev/null 2>&1; then
        eval "$(glab completion -s zsh)"
      fi

      if [ -r /opt/homebrew/opt/bitwarden-cli/share/zsh/site-functions/_bw ]; then
        source /opt/homebrew/opt/bitwarden-cli/share/zsh/site-functions/_bw
      fi

      if command -v terraform >/dev/null 2>&1; then
        autoload -Uz bashcompinit
        bashcompinit
        complete -o nospace -C "$(command -v terraform)" terraform
      fi
      
      # CASE-INSENSITIVE AUTOCOMPLETE
      zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"

      # Keybindings
      bindkey "^]" backward-kill-line
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[5D" backward-word
      bindkey "^[[5C" forward-word
      
      # Eclipse-style directory navigation (move up directories)
      # Usage: type ".." to go up one directory, "..." to go up two, etc.
      ..() { builtin cd ..; }
      ...() { builtin cd ../..; }
      ....() { builtin cd ../../..; }
      .....() { builtin cd ../../../..; }
      .claude() { builtin cd /Users/gareth/.claude/; }
      .codex() { builtin cd /Users/gareth/.codex/; }

      acli-jira-login() {
        if [ -z "$ATLASSIAN_TOKEN" ]; then
          echo "ATLASSIAN_TOKEN is not set. Populate $HOME/nix/secrets/atlassian/token first." >&2
          return 1
        fi

        printf '%s\n' "$ATLASSIAN_TOKEN" | acli jira auth login \
          --site "symphonyda.atlassian.net" \
          --email "garethfongkf@phillip.com.sg" \
          --token
      }

      claude-session-ids() {
        local project_folder
        project_folder="$(pwd | sed 's#/#-#g')"
        cat ~/.claude/projects/"$project_folder"/*.jsonl | jq -r .sessionId | sort | uniq
      }
      
     # echo "[ZSH INIT] Loaded by Home Manager"
    '';
  };
}
