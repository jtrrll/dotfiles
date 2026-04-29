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
              for _a in ${
                lib.escapeShellArgs (
                  map (t: "${worktreeDir}/${baseNameOf t}") [ config.home.file.worktrees.target ]
                )
              }; do
                if [ "$entry" = "$_a" ]; then
                  continue 2
                fi
              done
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
      launchd.agents = lib.mkIf pkgs.stdenv.isDarwin {
        maintain-worktree-dir = {
          config = {
            ProgramArguments = [ (lib.getExe maintainWorktreeDir) ];
            RunAtLoad = true;
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/maintain_worktree_dir.err";
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/maintain_worktree_dir.log";
            StartCalendarInterval = lib.hm.darwin.mkCalendarInterval "08:00";
          };
          enable = true;
        };
      };
      systemd.user = lib.mkIf (!pkgs.stdenv.isDarwin) {
        services.maintain-worktree-dir = {
          Service = {
            Type = "oneshot";
            ExecStart = lib.getExe maintainWorktreeDir;
          };
          Unit.Description = "Daily worktree cleanup for ~/worktrees";
        };
        timers.maintain-worktree-dir = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnCalendar = "08:00";
            Persistent = true;
          };
          Unit.Description = "Daily worktree cleanup for ~/worktrees";
        };
      };
    }
  );
}
