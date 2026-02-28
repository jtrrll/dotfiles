{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.terminal =
    { lib, pkgs, ... }:
    {
      imports =
        let
          constants = import ./constants.nix;
        in
        [
          ./bat.nix
          ./direnv.nix
          (import ./emulator.nix { inherit constants; })
          (import ./file_system.nix {
            snekcheck = inputs.snekcheck.packages.${pkgs.stdenv.hostPlatform.system}.default;
          })
          (import ./multiplexer.nix { inherit constants; })
          ./shell.nix
          ./system_info.nix
        ];

      options.dotfiles.terminal = {
        enable = lib.mkEnableOption "jtrrll's terminal configuration";
      };
    };
}
