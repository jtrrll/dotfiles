{home-manager, ...}: let
  constants = import ./constants.nix;
in {
  forEachSystem = f:
    builtins.listToAttrs (builtins.map (system: {
        name = system;
        value = f system;
      })
      constants.systems);
  mkHomeConfiguration = {
    homeDirectory,
    pkgs,
    username,
    vscode-extensions,
  }:
    home-manager.lib.homeManagerConfiguration {
      modules = [./home.nix];
      inherit pkgs;
      extraSpecialArgs =
        {
          inherit username homeDirectory vscode-extensions;
        }
        // constants;
    };
}
