{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.ai =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        ./claude

        ./env.nix
        ./mcp.nix
      ];

      config = lib.mkIf config.dotfiles.ai.enable {
        dotfiles.ai.packages = [ pkgs.jq ];
      };

      options.dotfiles.ai = {
        enable = lib.mkEnableOption "jtrrll's AI configuration";
      };
    };
}
