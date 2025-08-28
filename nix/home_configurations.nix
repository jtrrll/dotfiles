{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.homeConfigurations = builtins.addErrorContext "while defining home configurations" (
    let
      ### start "impure" ###
      HOME = builtins.getEnv "HOME";
      SYSTEM = builtins.currentSystem;
      USER = builtins.getEnv "USER";
      ### end "impure" ###
      mkConfig =
        cfg:
        assert builtins.isAttrs cfg;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = (builtins.attrValues self.homeModules) ++ [
            {
              home = {
                homeDirectory = HOME;
                stateVersion = "23.11";
                username = USER;
              };
            }
            {
              jtrrllDotfiles = {
                bat.enable = true;
                browsers.brave.enable = true;
                codeDirectory.enable = true;
                editors = {
                  neovim.enable = true;
                  vscode.enable = true;
                };
                fileSystem.enable = true;
                gaming.enable = true;
                git.enable = true;
                homeManager.enable = true;
                mediaPlayback.enable = true;
                musicLibrary.enable = true;
                nix.enable = true;
                repeat.enable = true;
                screensavers.enable = true;
                systemInfo.enable = true;
                terminal.enable = true;
                theme = {
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
                  enable = true;
                };
              };
            }
            cfg
          ];
        };
      pkgs = import inputs.nixpkgs {
        inherit SYSTEM;
        overlays = [ self.overlays.default ];
      };
    in
    {
      default = mkConfig { };
      work = mkConfig { jtrrllDotfiles.gaming.enable = lib.mkForce false; };
    }
  );
}
