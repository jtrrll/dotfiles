{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      agentsDir = ./claude_agents;
      mcpServers = {
        playwright = {
          type = "stdio";
          command = "${pkgs.bun}/bin/bunx";
          args = [ "@playwright/mcp@latest" ];
        };
      };
    };
  };

  options.dotfiles.ai = {
    enable = lib.mkEnableOption "jtrrll's AI configuration";
  };
}
