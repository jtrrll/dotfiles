{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      agentsDir = ./agents;
      rulesDir = ./rules;
    };
  };
}
