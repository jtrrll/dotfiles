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
      cloneWithWorktrees = lib.getExe (
        pkgs.git-clone-with-worktrees.override {
          git = config.programs.git.package;
        }
      );
    in
    {
      programs = {
        git.settings.alias.clone-with-worktrees = lib.removeSuffix "\n" ''
          !${cloneWithWorktrees} --bare-dest "${codeDir}" --worktree-dest "${worktreeDir}"
        '';
        opencode.context = ''
          # Code Storage

          Repositories are stored as bare clones in `${codeDir}`.
          Worktrees are checked out into `${worktreeDir}`.

          Use `git clone-with-worktrees <url>` to clone a repo with this layout.
          Never work directly in `${codeDir}`; always use a worktree in `${worktreeDir}`.
        '';
      };
    }
  );
}
