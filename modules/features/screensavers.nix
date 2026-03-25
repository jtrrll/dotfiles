{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager = {
    bonsai =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.programs.bonsai;
      in
      {
        options.programs.bonsai = {
          enable = lib.mkEnableOption "a bonsai tree screensaver";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.bonsai ];
        };
      };
    matrix =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.programs.matrix;
      in
      {
        options.programs.matrix = {
          enable = lib.mkEnableOption "a matrix rain screensaver";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.matrix ];
        };
      };
  };
}
