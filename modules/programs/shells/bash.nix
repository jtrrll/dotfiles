{
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historyFileSize = 1000000;
    historySize = 1000000;
    sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Silence direnv logs
      EDITOR = "vim";
    };
    initExtra = ''
      # Set prompt
      format_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
      }

      if [ -n "$SSH_CLIENT" ]; then
        PS1='\[\033[34m\]\u@\h \[\033[35m\]\W \[\033[33m\]$(format_git_branch)\[\033[32m\]$ \[\033[0m\]' # username@host dir branch $
      else
        PS1='\[\033[35m\]\W \[\033[33m\]$(format_git_branch)\[\033[32m\]$ \[\033[0m\]' # dir branch $
      fi

      # Improve command history
      shopt -s histappend         # append history instead of rewriting it
      HISTTIMEFORMAT='%F %T '     # store full date and time for each command
      shopt -s cmdhist            # one command per line
      PROMPT_COMMAND='history -a' # write history to file after each command

      # Use the up and down arrow keys for finding a command in history
      bind '"\e[A":history-search-backward'
      bind '"\e[B":history-search-forward'

      # Improve completion
      bind 'set completion-ignore-case on'
      bind 'set completion-query-items -1'
      bind 'set show-all-if-unmodified on'
      bind 'set skip-completed-text on'
    '';
  };
}
