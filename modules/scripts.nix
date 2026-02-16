{ inputs, self, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.devenv.scripts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports = lib.attrValues inputs.justix.modules.devenv;

      justix = {
        enable = true;
        config.recipes =
          let
            pkgToRecipe = pkg: {
              attributes.doc = pkg.meta.description;
              commands = "@${lib.getExe pkg} {{ args }}";
              parameters = [ "*args" ];
            };
            rootPath = config.devenv.root;
          in
          {
            fmt = {
              attributes.doc = "Formats and lints files";
              commands = ''
                @find "{{ paths }}" ! -path '*/.*' -exec ${
                  lib.getExe inputs.snekcheck.packages.${system}.default
                } --fix {} +
                @nix fmt -- {{ paths }}
              '';
              parameters = [ "*paths='.'" ];
            };
            list = {
              attributes = {
                default = true;
                doc = "Lists available recipes";
                private = true;
              };
              commands = "@just --list";
            };
            activate = pkgToRecipe (self.packages.${system}.activate.override { inherit rootPath; });
            update-docs = pkgToRecipe self.packages.${system}.update-docs;
          };
      };
    };
}
