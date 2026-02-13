{ inputs, self, ... }:
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
        ./mcp.nix
      ];

      config = lib.mkIf config.dotfiles.ai.enable (
        let
          ai = lib.evalModules {
            modules = lib.optionals (self.modules ? ai) (lib.attrValues self.modules.ai) ++ [
              {
                inherit (config.dotfiles.ai) packages;
                harness = pkgs.claude-code;
                _module.args = { inherit pkgs; };
              }
            ];
          };
        in
        {
          dotfiles.ai.packages = [
            config.programs.bash.package
            config.programs.git.package

            pkgs.curlMinimal
            pkgs.gh
            pkgs.jq
            (pkgs.mermaid-cli.override { chromium = config.programs.brave.finalPackage; })
            pkgs.ripgrep
            pkgs.uutils-coreutils-noprefix
            pkgs.uutils-findutils
            pkgs.which
          ];
          programs.claude-code = {
            enable = true;
            enableMcpIntegration = true;
            agentsDir = ./claude/agents;
            rulesDir = ./claude/rules;
            package = ai.config.finalHarness;
          };
        }
      );

      options.dotfiles.ai = {
        enable = lib.mkEnableOption "jtrrll's AI configuration";
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "The set of packages to appear in the AI environment.";
        };
      };
    };
}
