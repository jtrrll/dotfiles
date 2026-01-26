{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./claude
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          type = "stdio";
          command = "${pkgs.bun}/bin/bunx";
          args = [ "@upstash/context7-mcp" ];
        };
      };
    };
  };

  options.dotfiles.ai = {
    enable = lib.mkEnableOption "jtrrll's AI configuration";
  };
}
