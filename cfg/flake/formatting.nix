{ inputs, lib, ... }: {
  config.perSystem = {
    config.treefmt = {
      imports = [
        (import inputs.nix-lib { inherit lib; }).modules.treefmt.default
      ];
      programs = {
        biome.enable = true;
        gofumpt.enable = true;
        keep-sorted.enable = true;
        ruff-check.enable = true;
        ruff-format.enable = true;
        rustfmt = {
          enable = true;
          edition = "2024";
        };
      };
    };
  };
}
