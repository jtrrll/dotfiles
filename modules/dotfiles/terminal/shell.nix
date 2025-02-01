{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs = {
      bash = {
        enable = true;
        historyControl = [
          "ignoredups"
          "ignorespace"
        ];
        historyFileSize = 1000000;
        historySize = 1000000;
        initExtra = ''
          # Set prompt
          format_git_branch() {
            git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
          }

          if [ -n "$SSH_CLIENT" ]; then
            # username@host dir branch $
            PS1='\[\033[34m\]\u@\h \[\033[35m\]\W \[\033[33m\]$(format_git_branch)\[\033[32m\]$\[\033[0m\] \[\e[6 q\]'
          else
            # dir branch $
            PS1='\[\033[35m\]\W \[\033[33m\]$(format_git_branch)\[\033[32m\]$\[\033[0m\] \[\e[6 q\]'
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
      fish = {
        enable = true;
        interactiveShellInit = ''
          set --erase fish_greeting

          function fish_prompt
            set --local last_status $status

            if set --query SSH_CLIENT
              set_color blue
              echo -n (whoami)'@'(hostname)' '
            end

            set_color magenta
            echo -n (basename $PWD)' '

            set --local branch (git branch --show-current 2>/dev/null)
            if test -n $branch
              set_color yellow
              echo -n $branch' '
            end

            if test $last_status -eq 0
              set_color green
            else
              set_color red
            end
            echo -n '> '

            set_color normal
            echo -ne '\e[6 q'
          end
        '';
      };
    };
  };
}
