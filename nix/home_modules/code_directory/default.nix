{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.codeDirectory.enable (
    let
      codeDirGitFetch = pkgs.writeShellApplication {
        name = "code-dir-git-fetch";
        runtimeInputs = [
          pkgs.git
          pkgs.uutils-coreutils-noprefix
          pkgs.uutils-findutils
        ];
        text =
          let
            codeDir = "${config.home.homeDirectory}/code";
          in
          ''
            printf "[code-dir-git-fetch] scanning %s...\n" "${codeDir}"
            find "${codeDir}" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
              if [ -d "$dir/.git" ]; then
                printf "[code-dir-git-fetch] fetching: %s\n" "$dir"
                if ! git -C "$dir" fetch --all --quiet; then
                  printf "[code-dir-git-fetch] failed: %s\n" "$dir"
                fi
              fi
            done
          '';
      };
    in
    {
      home.file.code = {
        target = "code/README.md";
        text = ''
          # ~/code

          A working directory for code. All repositories *should* be stored on an external Git server.

          ## Services

          <!-- TODO: Implement snekcheck service -->
          1. Daily Git fetch
          2. Monthly top-level snekcheck

        '';
      };
      launchd.agents = lib.mkIf pkgs.stdenv.isDarwin {
        code-dir-git-fetch = {
          config = {
            Label = "code-dir-git-fetch";
            ProgramArguments = [ "${codeDirGitFetch}/bin/code-dir-git-fetch" ];
            RunAtLoad = true;
            StandardErrorPath = "/tmp/code_dir_git_fetch.err";
            StandardOutPath = "/tmp/code_dir_git_fetch.log";
            StartCalendarInterval = {
              Hour = 8;
              Minute = 0;
            };
          };
          enable = true;
        };
      };
      systemd.user = lib.mkIf (!pkgs.stdenv.isDarwin) {
        services.code-dir-git-fetch = {
          Service = {
            Type = "oneshot";
            ExecStart = "${codeDirGitFetch}/bin/code-dir-git-fetch";
          };
          Unit.Description = "Daily Git fetch for all repos in ~/code";
        };
        timers.code-dir-git-fetch = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnCalendar = "08:00";
            Persistent = true;
          };
          Unit.Description = "Daily Git fetch for all repos in ~/code";
        };
      };
    }
  );

  options.jtrrllDotfiles.codeDirectory = {
    enable = lib.mkEnableOption "jtrrll's code directory configuration";
  };
}
