{ inputs, self, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./scripts.nix
  ];

  config.flake.modules.homeManager.dotfiles =
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
                  self.packages.${pkgs.stdenv.hostPlatform.system}.gitEzSwitch.override {
                    git = config.programs.git.package;
                  }
                )
              }";
              open = "!${
                lib.getExe (
                  self.packages.${pkgs.stdenv.hostPlatform.system}.gitOpen.override {
                    git = config.programs.git.package;
                  }
                )
              }";
              trim = "!${
                lib.getExe (
                  self.packages.${pkgs.stdenv.hostPlatform.system}.gitTrim.override {
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
    };
}
