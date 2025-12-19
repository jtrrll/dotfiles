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
        atlassian = {
          type = "sse";
          url = "https://mcp.atlassian.com/v1/sse";
        };
        github = {
          type = "http";
          url = "https://api.githubcopilot.com/mcp/";
          headers.Authorization = "Bearer \${GITHUB_PERSONAL_ACCESS_TOKEN}";
        };
        playwright = {
          type = "stdio";
          command = "${pkgs.bun}/bin/bunx";
          args = [ "@playwright/mcp@latest" ];
        };
        sentry = {
          type = "http";
          url = "https://mcp.sentry.dev/mcp";
        };
      };
    };
  };

  options.dotfiles.ai = {
    enable = lib.mkEnableOption "jtrrll's AI configuration";
  };
}
