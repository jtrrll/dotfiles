{ inputs, self, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./scripts.nix
  ];

  flake.modules.homeManager.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.dotfiles.git.enable {
        programs.git = {
          enable = true;
          settings = {
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

      options.dotfiles.git = {
        enable = lib.mkEnableOption "jtrrll's Git configuration";
      };
    };
}
