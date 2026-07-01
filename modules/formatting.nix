{ self, ... }:
{
  config.perSystem =
    { inputs', pkgs, ... }:
    {
      config = {
        checks.snekcheck =
          pkgs.runCommand "snekcheck"
            {
              buildInputs = [ inputs'.snekcheck.packages.default ];
            }
            ''
              find ${self}/** -exec snekcheck {} +
              touch $out
            '';
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
