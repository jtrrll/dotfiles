{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {
      checks.moduleIsolation =
        let
          moduleEvaluators = {
            ai =
              module:
              lib.evalModules {
                modules = [
                  {
                    _module.args = { inherit pkgs; };
                  }
                  module
                ];
              };
            devenv =
              module:
              inputs.devenv.lib.mkEval {
                inherit pkgs lib;
                inputs = { };
                modules = [ module ];
              };
            flake =
              module:
              inputs.flake-parts.lib.mkFlake { inherit inputs; } {
                imports = [
                  module
                  { config.flake.modules = lib.mkDefault { }; }
                ];
                systems = [ system ];
              };
            homeManager =
              module:
              inputs.home-manager.lib.homeManagerConfiguration {
                modules = [
                  {
                    home = rec {
                      homeDirectory = "/home/${username}";
                      stateVersion = "23.11";
                      username = "test";
                    };
                  }
                  module
                ];
                pkgs = import inputs.nixpkgs-home-manager {
                  inherit system;
                };
              };
            nixos =
              module:
              inputs.nixpkgs-nixos.lib.nixosSystem {
                inherit system;
                modules = [
                  module
                  {
                    system.stateVersion = "25.05";
                  }
                ];
              };
          };
          extractSubModules =
            flakeModule:
            lib.flatten (
              lib.mapAttrsToList (
                class: lib.mapAttrsToList (name: module: { inherit class name module; })
              ) flakeModule.modules
            );
          testSubModule =
            {
              class,
              module,
              ...
            }:
            let
              evaluator = lib.getAttr class moduleEvaluators;
              result = builtins.tryEval (evaluator module);
            in
            result.success;

          flakeModulePaths = (self.lib.modules-tree.withLib lib).files;
          results = lib.concatMap (
            flakeModulePath:
            lib.pipe flakeModulePath [
              moduleEvaluators.flake
              extractSubModules
              (lib.map (subModule: {
                inherit flakeModulePath;
                inherit (subModule) class name;
                isolated = testSubModule subModule;
              }))
            ]
          ) flakeModulePaths;
        in
        pkgs.runCommand "module-isolation-test"
          {
            nativeBuildInputs = [
              pkgs.gum
              pkgs.jq
            ];
            passthru = { inherit results; };
          }
          (
            let
              resultsJson = builtins.toJSON results;
            in
            ''
              gum style \
                --bold --border=rounded \
                --border-foreground=63 --foreground=212 \
                --padding "1 2" \
                "Module Isolation Test"

              echo

              echo '${resultsJson}' \
                | jq -r '
                    ["CLASS", "NAME", "ISOLATED"],
                    (.[] | [
                      .class,
                      .name,
                      (if .isolated
                        then "\u001b[32m✓\u001b[0m"
                        else "\u001b[31m✗\u001b[0m"
                      end)
                    ])
                    | @csv
                  ' \
                | gum table --print --border.foreground=63

              echo

              total="$(echo '${resultsJson}' | jq length)"
              failures="$(
                echo '${resultsJson}' \
                  | jq '[.[] | select(.isolated == false)] | length'
              )"
              gum style \
                --border=rounded \
                --border-foreground=63 \
                --padding "0 1" \
                "Total modules: $total" "Failures: $failures"

              echo '${resultsJson}' > $out
              if [ "$failures" -gt 0 ]; then
                exit 1
              fi
            ''
          );
    };
}
