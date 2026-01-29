{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.terminal =
    { lib, ... }:
    {
      imports =
        let
          constants = import ./constants.nix;
        in
        [
          ./screensavers

          ./bat.nix
          ./direnv.nix
          (import ./emulator.nix { inherit constants; })
          ./file_system.nix
          (import ./multiplexer.nix { inherit constants; })
          ./repeat.nix
          ./shell.nix
          ./system_info.nix
        ];

      options.dotfiles.terminal = {
        enable = lib.mkEnableOption "jtrrll's terminal configuration";
      };
    };
}
