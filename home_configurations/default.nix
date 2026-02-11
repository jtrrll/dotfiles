{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations =
    let
      ### start "impure" ###
      HOME = builtins.getEnv "HOME";
      SYSTEM = builtins.currentSystem;
      USER = builtins.getEnv "USER";
      ### end "impure" ###
      mkHomeConfiguration =
        modules:
        assert lib.isList modules && lib.all lib.isAttrs modules;
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            lib.attrValues self.homeModules
            ++ [
              {
                home = {
                  homeDirectory = HOME;
                  username = USER;
                  sessionVariables = {
                    EDITOR = "nvim";
                    VISUAL = "zeditor";
                  };
                };
              }
              {
                dotfiles = {
                  ai.enable = lib.mkDefault true;
                  bat.enable = lib.mkDefault true;
                  browsers.brave.enable = lib.mkDefault true;
                  codeDirectory.enable = lib.mkDefault true;
                  editors = {
                    neovim.enable = lib.mkDefault true;
                    zed.enable = lib.mkDefault true;
                  };
                  fileSystem.enable = lib.mkDefault true;
                  gaming.enable = lib.mkDefault true;
                  git.enable = lib.mkDefault true;
                  homeManager.enable = lib.mkDefault true;
                  musicLibrary.enable = lib.mkDefault true;
                  nix.enable = lib.mkDefault true;
                  repeat.enable = lib.mkDefault true;
                  screensavers.enable = lib.mkDefault true;
                  ssh.enable = lib.mkDefault true;
                  systemInfo.enable = lib.mkDefault true;
                  terminal.enable = lib.mkDefault true;
                  theme = {
                    enable = lib.mkDefault true;
                    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
                  };
                };
              }
            ]
            ++ modules;
        };
      pkgs = import inputs.nixpkgs-home-manager {
        inherit SYSTEM;
        overlays = [ self.overlays.default ];
      };
    in
    {
      default = mkHomeConfiguration [
        {
          home.stateVersion = "23.11";
        }
      ];
      work = mkHomeConfiguration [
        {
          dotfiles = {
            gaming.enable = false;
            musicLibrary.enable = false;
          };
          home.stateVersion = "23.11";
        }
      ];
    };
}
