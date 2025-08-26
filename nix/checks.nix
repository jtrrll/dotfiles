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
