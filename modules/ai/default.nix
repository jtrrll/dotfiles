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
      ];

      config = lib.mkIf config.dotfiles.ai.enable {
        dotfiles.ai.packages = [ pkgs.bun ];
        programs.mcp = {
          enable = true;
          servers = {
            context7 = {
              type = "stdio";
              command = "bunx";
              args = [ "@upstash/context7-mcp" ];
            };
          };
        };
      };

      options.dotfiles.ai = {
        enable = lib.mkEnableOption "jtrrll's AI configuration";
      };
    };
}
