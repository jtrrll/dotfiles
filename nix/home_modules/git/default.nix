{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.git.enable {
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

  imports = [
    ./navigation.nix
    ./operations.nix
  ];

  options.jtrrllDotfiles.git = {
    enable = lib.mkEnableOption "jtrrll's Git configuration";
  };
}
