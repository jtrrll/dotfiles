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
      programs = {
        git.ignores = [
          ".opencode"
        ];
        opencode = {
          enableMcpIntegration = true;
          agents = ./agents;
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
            share = "disabled";
          };
          tui.theme = "system";
        };
      };
    })
    (lib.mkIf (options ? stylix) { stylix.targets.opencode.enable = false; })
  ];
}
