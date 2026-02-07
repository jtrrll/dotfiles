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
          flakeModulePaths = (self.lib.modules-tree.withLib lib).files;
          moduleEvaluators = {
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
              name,
              module,
              ...
            }:
            let
              evaluator = lib.getAttr class moduleEvaluators;
              result = builtins.tryEval (evaluator module);
            in
            {
              inherit class name;
              inherit (result) success;
            };

          results = lib.pipe flakeModulePaths [
            (lib.map (flakeModulePath: {
              path = flakeModulePath;
              flakeModule = moduleEvaluators.flake flakeModulePath;
            }))
            (lib.concatMap (x: lib.map (y: x // y) (extractSubModules x.flakeModule)))
            (lib.map testSubModule)
          ];
        in
        pkgs.runCommand "module-isolation-test"
          {
            nativeBuildInputs = [
              pkgs.jq
              pkgs.gum
              pkgs.util-linux
            ];
            passthru = { inherit results; };
          }
          (
            let
              resultsJson = builtins.toJSON results;
              hasFailures = lib.any (result: !result.success) results;
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
                    ["CLASS", "NAME", "SUCCESS"],
                    (.[] | [
                      .class,
                      .name,
                      (if .success
                        then "\u001b[32m✓\u001b[0m"
                        else "\u001b[31m✗\u001b[0m"
                      end)
                    ])
                    | @csv
                  ' \
                | gum table --print --border.foreground=63

              echo
              echo "Total modules: $(echo '${resultsJson}' | jq length)"
              echo "Failures: $(echo '${resultsJson}' | jq '[.[] | select(.success==false)] | length')"

              touch $out

              ${lib.optionalString hasFailures "exit 1"}
            ''
          );
    };
}
