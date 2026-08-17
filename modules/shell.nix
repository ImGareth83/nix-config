{ pkgs, config, ... }:

{
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-u" = "unix-line-discard";
      "\\C-]" = "kill-line";
      "\\e[H" = "beginning-of-line";
      "\\e[F" = "end-of-line";
      "\\eOH" = "beginning-of-line";
      "\\eOF" = "end-of-line";
    };
  };

  # ============================================================================
  # Shell configuration (Zsh)
  # ============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Use absolute path constructed from homeDirectory to avoid deprecation warning
    dotDir = "${config.home.homeDirectory}"; # So config goes to ~/.zshrc, not ~/.config/zsh/.zshrc
    envExtra = ''
      if [ -f "$HOME/nix/secrets/atlassian/token" ]; then
        export ATLASSIAN_TOKEN="$(tr -d '\r\n' < "$HOME/nix/secrets/atlassian/token")"
      fi
      export JIRA_URL="symphonyda.atlassian.net"
      export JIRA_EMAIL="gareth.fong@symphonyda.io"
    '';
    shellAliases = {
      k = "kubectl";
      a = "argocd";
      awssso = "aws sso login --sso-session symphonyda";
      awswhoami = "aws sts get-caller-identity";
      md = "markitdown";
      brave = "_open_https 'Brave Browser'";
      safari = "_open_https 'Safari'";
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
      export PATH="$HOME/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/Library/TeX/texbin:$PATH"
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh

      if [ -f "$HOME/nix/secrets/gitlab/token" ]; then
        export GITLAB_TOKEN="$(tr -d '\r\n' < "$HOME/nix/secrets/gitlab/token")"
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
      # Ctrl+[ is the same byte as Esc and cannot be made reliable across tools.
      bindkey -M emacs "^U" backward-kill-line
      bindkey -M viins "^U" backward-kill-line
      bindkey -M vicmd "^U" backward-kill-line
      bindkey -M emacs "^]" kill-line
      bindkey -M viins "^]" kill-line
      bindkey -M vicmd "^]" kill-line
      # Make Option+Backspace stop at punctuation; keep Ctrl+W's default behavior.
      autoload -Uz backward-kill-word-match
      zle -N punctuation-backward-kill-word backward-kill-word-match
      zstyle ':zle:punctuation-backward-kill-word' word-style normal
      zstyle ':zle:punctuation-backward-kill-word' word-chars ""
      bindkey -M emacs "^[^?" punctuation-backward-kill-word
      bindkey -M emacs "^[^H" punctuation-backward-kill-word
      bindkey -M viins "^[^?" punctuation-backward-kill-word
      bindkey -M viins "^[^H" punctuation-backward-kill-word
      # Keep Ctrl+Left/Right available for macOS desktop switching.
      # Support the common Option+Left/Right terminal escape sequences instead.
      bindkey "^[b" backward-word
      bindkey "^[f" forward-word
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;3C" forward-word
      bindkey -M emacs "^[[H" beginning-of-line
      bindkey -M emacs "^[[F" end-of-line
      bindkey -M emacs "^[OH" beginning-of-line
      bindkey -M emacs "^[OF" end-of-line
      bindkey -M viins "^[[H" beginning-of-line
      bindkey -M viins "^[[F" end-of-line
      bindkey -M viins "^[OH" beginning-of-line
      bindkey -M viins "^[OF" end-of-line
      bindkey -M vicmd "^[[H" beginning-of-line
      bindkey -M vicmd "^[[F" end-of-line
      bindkey -M vicmd "^[OH" beginning-of-line
      bindkey -M vicmd "^[OF" end-of-line
      
      # Eclipse-style directory navigation (move up directories)
      # Usage: type ".." to go up one directory, "..." to go up two, etc.
      ..() { builtin cd ..; }
      ...() { builtin cd ../..; }
      ....() { builtin cd ../../..; }
      .....() { builtin cd ../../../..; }
      .claude() { builtin cd /Users/gareth/.claude/; }
      .codex() { builtin cd /Users/gareth/.codex/; }

      _open_https() {
        local app="$1"
        local target="$2"

        if [ -z "$target" ]; then
          echo "Usage: $0 <domain-or-url>" >&2
          return 1
        fi

        case "$target" in
          http://*) target="https://''${target#http://}" ;;
          https://*) ;;
          *) target="https://$target" ;;
        esac

        open -a "$app" "$target"
      }

      acli-jira-login() {
        if [ -z "$ATLASSIAN_TOKEN" ]; then
          echo "ATLASSIAN_TOKEN is not set. Populate $HOME/nix/secrets/atlassian/token first." >&2
          return 1
        fi

        printf '%s\n' "$ATLASSIAN_TOKEN" | acli jira auth login \
          --site "$JIRA_URL" \
          --email "$JIRA_EMAIL" \
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
