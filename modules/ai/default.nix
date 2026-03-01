{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.ai =
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

      options.dotfiles.ai = {
        enable = lib.mkEnableOption "jtrrll's AI configuration" // {
          default = true;
        };
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "The set of packages to appear in the AI environment.";
        };
      };

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
            settings.statusLine = {
              type = "command";
              command = ''
                input=$(cat)
                cwd=$(echo "$input" | jq -r '.workspace.current_dir')
                output=""

                output+="$(printf '\033[35m')"
                if [ "$cwd" = "$HOME" ]; then
                  output+="~ "
                else
                  output+="$(basename "$cwd") "
                fi

                branch=$(cd "$cwd" && git --no-optional-locks branch --show-current 2>/dev/null)
                if [ -n "$branch" ]; then
                  output+="$(printf '\033[33m')$branch "
                fi

                ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
                if [ -n "$ctx_pct" ]; then
                  if [ "$ctx_pct" -ge 85 ]; then
                    ctx_color='\033[31m'  # red
                  else
                    ctx_color='\033[32m'  # green
                  fi
                  output+="$(printf "$ctx_color")ctx:''${ctx_pct}% "
                fi

                total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
                total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
                if [ -n "$total_in" ] && [ -n "$total_out" ]; then
                  # Format tokens as K or M
                  if [ "$total_in" -ge 1000000 ]; then
                    in_fmt="$(awk "BEGIN {printf \"%.1fM\", $total_in/1000000}")"
                  elif [ "$total_in" -ge 1000 ]; then
                    in_fmt="$(awk "BEGIN {printf \"%.1fK\", $total_in/1000}")"
                  else
                    in_fmt="$total_in"
                  fi

                  if [ "$total_out" -ge 1000000 ]; then
                    out_fmt="$(awk "BEGIN {printf \"%.1fM\", $total_out/1000000}")"
                  elif [ "$total_out" -ge 1000 ]; then
                    out_fmt="$(awk "BEGIN {printf \"%.1fK\", $total_out/1000}")"
                  else
                    out_fmt="$total_out"
                  fi

                  output+="$(printf '\033[0m')in:''${in_fmt} out:''${out_fmt} "
                fi

                output+="$(printf '\033[0m')"
                printf "%s" "$output"
              '';
            };
          };
        }
      );
    };
}
