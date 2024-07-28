{
  programs.zsh = {
    enable = true;
    initExtra = ''
      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

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
