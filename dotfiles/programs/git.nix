{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.programs.git.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user = {
          name = "Jackson Terrill";
          useConfigOnly = true; # require an email to be defined in local .gitconfig
        };
      };
    };
  };

  options = {
    dotfiles.programs.git = {
      enable = lib.mkEnableOption "Git";
    };
  };
}
