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
          command = "${pkgs.nodejs}/bin/npx";
          env.PATH = "${pkgs.nodejs}/bin:{env:PATH}";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };
        nix = {
          type = "stdio";
          command = lib.getExe pkgs.mcp-nixos;
        };
      };
    })
  ];
}
