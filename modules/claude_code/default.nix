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
        { programs.claude-code.enable = lib.mkDefault true; }
        (lib.mkIf config.programs.claude-code.enable {
          home.packages = [
            pkgs.curlMinimal
            pkgs.gh
            pkgs.jq
            pkgs.ripgrep
            pkgs.uutils-coreutils-noprefix
            pkgs.uutils-findutils
            pkgs.which
          ]
          ++ (
            if config.programs.brave.enable then
              [
                (pkgs.mermaid-cli.override { chromium = config.programs.brave.finalPackage; })
              ]
            else
              [ ]
          );
          programs = {
            claude-code = {
              enableMcpIntegration = true;
              agentsDir = ./agents;
              rulesDir = ./rules;
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
            git.ignores = lib.mkIf config.programs.git.enable [
              ".claude/*.local.*"
              "*.log"
            ];
          };
        })
      ];
    };
}
