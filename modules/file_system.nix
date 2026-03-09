{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager = {
    dotfiles =
      {
        config,
        lib,
        ...
      }:
      {
        config = lib.mkMerge [
          {
            programs = {
              eza.enable = lib.mkDefault true;
              fd.enable = lib.mkDefault true;
              fzf.enable = lib.mkDefault true;
              ripgrep.enable = lib.mkDefault true;
              snekcheck.enable = lib.mkDefault true;
              zoxide.enable = lib.mkDefault true;
            };
          }
          (lib.mkIf config.programs.eza.enable {
            programs.eza = {
              extraOptions = [ "--header" ];
              git = true;
              icons = "auto";
            };
          })
          (lib.mkIf config.programs.zoxide.enable {
            programs.zoxide.options = [ "--cmd cd" ];
          })
        ];
      };
    snekcheck =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.programs.snekcheck;
      in
      {
        options.programs.snekcheck = {
          enable = lib.mkEnableOption "snekcheck";
          package = lib.mkOption {
            type = lib.types.package;
            description = "The snekcheck package to use";
            inherit (inputs.snekcheck.packages.${pkgs.stdenv.hostPlatform.system}) default;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ cfg.package ];
        };
      };
  };
}
