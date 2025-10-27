{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      agentsDir = ./claude_agents;
      mcpServers = {
        atlassian = {
          type = "http";
          url = "https://mcp.atlassian.com/v1/sse";
        };
        filesystem = {
          type = "stdio";
          command = "${pkgs.bun}/bin/bunx";
          args = [ "@modelcontextprotocol/server-filesystem" ];
        };
        git = {
          type = "stdio";
          command = "${pkgs.bun}/bin/bunx";
          args = [ "@cyanheads/git-mcp-server@latest" ];
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

  options.jtrrllDotfiles.ai = {
    enable = lib.mkEnableOption "jtrrll's AI configuration";
  };
}
