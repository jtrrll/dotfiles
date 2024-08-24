{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
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
}
