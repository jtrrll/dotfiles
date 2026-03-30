{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.snekcheck =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.snekcheck;
      snekcheck = inputs.snekcheck.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      options.programs.snekcheck = {
        enable = lib.mkEnableOption "snekcheck";
        package = lib.mkOption {
          type = lib.types.package;
          description = "The snekcheck package to use";
          default = snekcheck;
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ cfg.package ];
      };
    };
}
