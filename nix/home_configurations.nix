{
  config,
  inputs,
  ...
}:
{
  flake.homeConfigurations =
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
          modules = (builtins.attrValues config.flake.homeModules) ++ [
            {
              home = {
                homeDirectory = HOME;
                stateVersion = "23.11";
                username = USER;
              };
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
              }
              // cfg;
            }
          ];
        };
      pkgs = import inputs.nixpkgs {
        inherit SYSTEM;
        overlays = [ config.flake.overlays.default ];
      };
    in
    {
      default = mkConfig { };
      headless = mkConfig {
        browsers.brave.enable = false;
        gaming.enable = false;
        screensavers.enable = false;
        theme.enable = false;
      };
      work = mkConfig { gaming.enable = false; };
    };
}
