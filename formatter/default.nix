{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = _: {
    treefmt = {
      programs = {
        deadnix.enable = true;
        nixfmt.enable = true;
        statix.enable = true;
      };
      settings.excludes = [ "*/hardware_configuration.nix" ];
    };
  };
}
