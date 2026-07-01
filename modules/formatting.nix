{
  config.perSystem = {
    config = {
      treefmt = {
        programs = {
          biome.enable = true;
          deadnix.enable = true;
          gofumpt.enable = true;
          keep-sorted.enable = true;
          nixfmt.enable = true;
          rustfmt = {
            enable = true;
            edition = "2024";
          };
          statix.enable = true;
        };
      };
    };
  };
}
