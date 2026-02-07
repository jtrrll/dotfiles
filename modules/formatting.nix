{ inputs, self, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { inputs', pkgs, ... }:
    {
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
          deadnix.enable = true;
          keep-sorted.enable = true;
          nixfmt.enable = true;
          statix.enable = true;
        };
        settings.excludes = [ "*/hardware_configuration.nix" ];
      };
    };
}
