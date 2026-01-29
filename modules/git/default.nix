{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.git =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkIf config.dotfiles.git.enable {
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
            ".claude"
            "*.log"
          ];
        };
      };

      imports = [
        ./scripts.nix
      ];

      options.dotfiles.git = {
        enable = lib.mkEnableOption "jtrrll's Git configuration";
      };
    };
}
