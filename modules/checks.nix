{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      checks = {
        nix-lint =
          pkgs.runCommandLocal "nix-lint"
            {
              buildInputs = [ pkgs.nixfmt ];
            }
            ''
              find ${self}/** -type f -name '*.nix' -exec nixfmt --check {} +
              touch $out
            '';
        snekcheck =
          pkgs.runCommandLocal "snekcheck"
            {
              buildInputs = [ inputs.snekcheck.packages.${system}.default ];
            }
            ''
              find ${self}/** -exec snekcheck {} +
              touch $out
            '';
      };
    };
}
