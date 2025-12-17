{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.git.enable {
    programs.git = {
      enable = true;
      settings = {
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user = {
          name = "Jackson Terrill";
          useConfigOnly = true; # require an email to be defined in local .gitconfig
        };
      };
      ignores = [
        ".claude/settings.local.json"
        "*.log"
      ];
    };
  };

  imports = [
    ./scripts.nix
  ];

  options.jtrrllDotfiles.git = {
    enable = lib.mkEnableOption "jtrrll's Git configuration";
  };
}
