{ config, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.edit =
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
      cfg = config.programs.edit;
    in
    {
      options.programs.edit = {
        enable = lib.mkEnableOption "edit";
        package = lib.mkOption {
          type = lib.types.package;
          description = "The edit package to use";
          default = packages.${pkgs.stdenv.hostPlatform.system}.edit;
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ cfg.package ];
      };
    };
}
