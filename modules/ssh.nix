{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.ssh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.dotfiles.ssh;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
            UseKeychain yes
          '';

          matchBlocks."*" = {
            addKeysToAgent = "yes";
          };
          includes = [ "${config.home.homeDirectory}/.ssh/hosts/*" ];
        };
      };

      options.dotfiles.ssh = {
        enable = lib.mkEnableOption "jtrrll's SSH configuration";
      };
    };
}
