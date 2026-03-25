{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.git.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.git.enable {
      programs.git.settings = {
        alias = {
          ezswitch = "!${
            lib.getExe (
              pkgs.git-ezswitch.override {
                git = config.programs.git.package;
              }
            )
          }";
          open = "!${
            lib.getExe (
              pkgs.git-open.override {
                git = config.programs.git.package;
              }
            )
          }";
          trim = "!${
            lib.getExe (
              pkgs.git-trim.override {
                git = config.programs.git.package;
              }
            )
          }";
        };
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."git@github.com:".insteadOf = "https://github.com/";
        user.useConfigOnly = true; # require an email to be defined in local .gitconfig
      };
    })
  ];
}
