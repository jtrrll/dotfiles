{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.codeStorage;
in
{
  config = lib.mkIf cfg.enable (
    let
      worktreeDir = "${config.home.homeDirectory}/worktrees";
      maintainWorktreeDir = pkgs.writeShellApplication rec {
        meta.mainProgram = name;
        name = "maintain-worktree-dir";
        runtimeInputs = [
          config.programs.git.package
          pkgs.uutils-coreutils-noprefix
          pkgs.uutils-findutils
        ];
        text = ''
          printf "[maintain-worktree-dir] cleaning %s...\n" "${worktreeDir}"
          if [ -d "${worktreeDir}" ]; then
            find "${worktreeDir}" -mindepth 1 -maxdepth 1 | while read -r entry; do
              if [ "$entry" = "${worktreeDir}/${baseNameOf config.home.file.worktrees.target}" ]; then
                continue
              fi
              if [ ! -d "$entry" ] || [ ! -f "$entry/.git" ]; then
                printf "[maintain-worktree-dir] removing non-worktree: %s\n" "$entry"
                rm -rf "$entry"
                continue
              fi
              parent_repo="$(git -C "$entry" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || true
              parent_repo="''${parent_repo%/.}"
              if [ -z "$parent_repo" ] || [ ! -d "$parent_repo" ]; then
                printf "[maintain-worktree-dir] removing orphaned worktree: %s\n" "$entry"
                rm -rf "$entry"
              fi
            done
          fi
        '';
      };
    in
    {
      home.file.worktrees = {
        target = "worktrees/README.md";
        text = ''
          # ~/worktrees

          Git worktrees for development.

          ## Daily Maintenance

          1. Remove non-worktree entries
          2. Remove orphaned worktrees

        '';
      };
      launchd.agents.maintain-worktree-dir = {
        enable = true;
        config = {
          ProgramArguments = [ (lib.getExe maintainWorktreeDir) ];
          ProcessType = "Background";
          RunAtLoad = true;
          StartCalendarInterval = lib.hm.darwin.mkCalendarInterval cfg.frequency;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/maintain-worktree-dir/launchd-stdout.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/maintain-worktree-dir/launchd-stderr.log";
        };
      };

      systemd.user = {
        services.maintain-worktree-dir = {
          Unit.Description = "Worktree cleanup for ~/worktrees";
          Service = {
            Type = "oneshot";
            ExecStart = lib.getExe maintainWorktreeDir;
          };
        };
        timers.maintain-worktree-dir = {
          Unit.Description = "Worktree cleanup for ~/worktrees";
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnCalendar = cfg.frequency;
            Persistent = true;
          };
        };
      };
    }
  );
}
