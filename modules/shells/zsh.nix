{
  programs.zsh = {
    enable = true;
    sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Silence direnv logs
      EDITOR = "vim";
    };
    initExtra = ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      # Source completions if available
      if [ -d /usr/local/completions ]; then
        autoload -U compinit; compinit
        for file in /usr/local/completions/*.zsh; do
          if [ -f "$file" ]; then
            . "$file"
          fi
        done
      fi

      # Set prompt
      format_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
      }
      setopt prompt_subst

      if [ -n "$SSH_CLIENT" ]; then
        PROMPT='%F{blue}%n@%m%f %F{magenta}%1~%f %F{green}%#%f ' # username@host dir branch %
      else
        PROMPT='%F{magenta}%1~%f %F{yellow}%"$(format_git_branch)%f%F{green}%#%f ' # dir branch %
      fi
    '';
  };
}
