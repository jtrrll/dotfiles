{
  config,
  lib,
  pkgs,
  ...
}:
{
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
}
