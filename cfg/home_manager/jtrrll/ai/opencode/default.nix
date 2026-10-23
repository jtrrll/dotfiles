{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.opencode.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.opencode.enable {
      home.sessionVariables.AGENT_HARNESS = config.programs.opencode.package.meta.mainProgram;
      programs = {
        git.ignores = [
          ".opencode"
        ];
        opencode = {
          package = pkgs.llm-agents.opencode2.overrideAttrs (prevAttrs: {
            postFixup = (prevAttrs.postFixup or "") + ''
              wrapProgram $out/bin/${prevAttrs.meta.mainProgram} \
                --set-default OPENCODE_DISABLE_FREE_MODELS 1
            '';
          });
          enableMcpIntegration = true;
          agents =
            let
              agentsDir = ./agents;
              agentFiles = lib.pipe (builtins.readDir agentsDir) [
                (lib.filterAttrs (_: type: type == "regular"))
                (lib.filterAttrs (name: _: lib.hasSuffix ".md" name))
                builtins.attrNames
              ];
            in
            lib.listToAttrs (
              map (
                name:
                let
                  baseName = lib.removeSuffix ".md" name;
                  hyphenated = builtins.replaceStrings [ "_" ] [ "-" ] baseName;
                in
                lib.nameValuePair hyphenated (agentsDir + "/${name}")
              ) agentFiles
            );
          context =
            let
              rulesDir = ./rules;
              ruleFiles = lib.pipe (builtins.readDir rulesDir) [
                (lib.filterAttrs (_: type: type == "regular"))
                (lib.filterAttrs (name: _: lib.hasSuffix ".md" name))
                (attrs: lib.sort (a: b: a < b) (builtins.attrNames attrs))
                (map (name: builtins.readFile (rulesDir + "/${name}")))
              ];
            in
            "# Rules\n\n" + lib.concatStringsSep "\n" ruleFiles;
          extraPackages = [
            # keep-sorted start
            pkgs.curlMinimal
            pkgs.gh
            pkgs.jq
            pkgs.keep-awake
            pkgs.ripgrep
            pkgs.uutils-coreutils-noprefix
            pkgs.uutils-findutils
            pkgs.which
            # keep-sorted end
          ]
          ++ (
            if config.programs.brave.enable then
              [
                (pkgs.mermaid-cli.override { chromium = config.programs.brave.finalPackage; })
              ]
            else
              [ ]
          );
          settings = {
            autoupdate = false;
            permission = {
              external_directory = {
                "/nix/store/**" = "allow";
                "/tmp/**" = "allow";
              };
              edit = {
                "/nix/store/**" = "deny";
              };
            };
            share = "disabled";
          };
          tui.theme = "system";
        };
      };
      xdg.configFile."opencode/cli.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/v2/cli.json";
        theme.name = "system";
        tabs.enabled = false;
      };
      xdg.configFile."opencode/plugins/zellij.ts".source =
        pkgs.zellij-agent-handler.integrations.opencode-plugin;
    })
    (lib.mkIf (options ? stylix) { stylix.targets.opencode.colors.enable = false; })
  ];
}
