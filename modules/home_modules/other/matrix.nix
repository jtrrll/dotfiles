{ config, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.matrix =
    let
      inherit (config) packages;
    in
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
        home.packages = [ packages.${pkgs.stdenv.hostPlatform.system}.matrix ];
      };
    };
}
