{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.git.enable {
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

  options.dotfiles.git = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the Git configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
