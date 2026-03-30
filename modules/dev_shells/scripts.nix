{
  config,
  inputs,
  ...
}:
{
  config.perSystem =
    let
      inherit (config.flake) homeConfigurations nixosConfigurations;
    in
    {
      lib,
      system,
      ...
    }:
    {
      config.devenv.modules = (lib.attrValues inputs.justix.modules.devenv) ++ [
        (
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
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
                  activate = pkgToRecipe (
                    pkgs.activate.override {
                      inherit rootPath;
                      homeConfigurations = lib.attrNames homeConfigurations;
                      nixosConfigurations = lib.attrNames nixosConfigurations;
                    }
                  );
                  update-docs = {
                    attributes.doc = "Updates documentation for the flake";
                    commands = ''
                      write-files
                      @nix run .#update-demo
                    '';
                  };
                };
            };
          }
        )
      ];
    };
}
