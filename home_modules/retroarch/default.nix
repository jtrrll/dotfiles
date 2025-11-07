{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.retroarch;

  enabledCores = lib.filterAttrs (_: core: core.enable) cfg.cores;
  resolvedCores = lib.mapAttrs (
    name: core:
    if core.package != null then
      core.package
    else
      pkgs.libretro.${name}
        or (throw "RetroArch core '${name}' not found in pkgs.libretro and no package specified")
  ) enabledCores;
in
{
  options.programs.retroarch = {
    enable = lib.mkEnableOption "RetroArch";

    package = lib.mkPackageOption pkgs "retroarch-bare" { };

    cores = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkEnableOption "RetroArch core";
              package = lib.mkPackageOption pkgs.libretro name {
                nullable = true;
                default = null;
                extraDescription = ''
                  If null, will automatically use pkgs.libretro.''${name} if available.
                '';
              };
            };
          }
        )
      );
      default = { };
      example = lib.literalExpression ''
        {
          mgba.enable = true;  # Uses pkgs.libretro.mgba
          snes9x = {
            enable = true;
            package = pkgs.libretro.snes9x.override { /* ... */ };
          };
          custom-core = {
            enable = true;
            package = pkgs.callPackage ./custom-core.nix { };
          };
        }
      '';
      description = ''
        RetroArch cores to enable. Cores will automatically use packages from
        pkgs.libretro if available, or you can provide custom core packages.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "RetroArch configuration settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (cfg.package.wrapper {
        inherit (cfg) settings;
        cores = lib.attrValues resolvedCores;
      })
    ];
  };
}
