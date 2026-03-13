{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    flake.modules.homeManager = {
      dotfiles =
        { lib, ... }:
        {
          config.programs.edit.enable = lib.mkDefault true;
        };
      edit =
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
              default = self.packages.${pkgs.stdenv.hostPlatform.system}.edit;
            };
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ cfg.package ];
          };
        };
    };
    perSystem =
      { pkgs, ... }:
      {
        config.packages.edit = pkgs.callPackage (
          { lib, writers }:
          (writers.writeNuBin "edit" { } (lib.readFile ./edit.nu)).overrideAttrs (oldAttrs: {
            meta = (oldAttrs.meta or { }) // {
              description = "Launches a text editor";
              license = lib.licenses.mit;
            };
          })
        ) { };
      };
  };
}
