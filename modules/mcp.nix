{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.dotfiles =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        { programs.mcp.enable = lib.mkDefault true; }
        (lib.mkIf config.programs.mcp.enable {
          programs.mcp.servers = {
            context7 = {
              type = "stdio";
              command = "${pkgs.bun}/bin/bunx";
              args = [ "@upstash/context7-mcp" ];
            };
          };
        })
      ];
    };
}
