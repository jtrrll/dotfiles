{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.presets =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.dotfiles.presets;
    in
    {
      options.dotfiles.presets = {
        minimal.enable = lib.mkEnableOption "jtrrll's minimal dotfiles";
        full.enable = lib.mkEnableOption "jtrrll's full dotfiles";
      };

      config.dotfiles = lib.mkMerge [
        (lib.mkIf cfg.minimal.enable {
          bat.enable = lib.mkDefault true;
          editors.neovim.enable = lib.mkDefault true;
          fileSystem.enable = lib.mkDefault true;
          git.enable = lib.mkDefault true;
          homeManager.enable = lib.mkDefault true;
          nix.enable = lib.mkDefault true;
          systemInfo.enable = lib.mkDefault true;
          terminal.enable = lib.mkDefault true;
        })
        (lib.mkIf cfg.full.enable {
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
          systemInfo.enable = lib.mkDefault true;
          terminal.enable = lib.mkDefault true;
          theme.enable = lib.mkDefault true;
        })
      ];
    };
}
