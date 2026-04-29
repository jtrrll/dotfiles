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
  options.services.codeStorage = {
    enable = lib.mkEnableOption "self-maintaining directories for source code and worktrees";
  };

  config = lib.mkIf cfg.enable (
    let
      codeDir = "${config.home.homeDirectory}/code";
      worktreeDir = "${config.home.homeDirectory}/worktrees";
      cloneWithWorktree = lib.getExe (
        pkgs.git-clone-with-worktree.override {
          git = config.programs.git.package;
        }
      );
    in
    {
      programs.git.settings.alias.clone-with-worktree = ''
        !name="''${2:-$(basename "$1" .git)}" && ${cloneWithWorktree} "$1" "${codeDir}/$name" "${worktreeDir}/$name"
      '';
    }
  );
}
