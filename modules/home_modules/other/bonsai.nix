{ config, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.bonsai =
    let
      inherit (config.flake) packages;
    in
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
        home.packages = [ packages.${pkgs.stdenv.hostPlatform.system}.bonsai ];
      };
    };
}
