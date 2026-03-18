{ inputs, ... }:
{
  imports = [ inputs.files.flakeModules.default ];

  config.perSystem =
    { pkgs, ... }:
    {
      config.files.files = [
        {
          path_ = "LICENSE";
          drv = pkgs.fetchurl {
            url = "https://www.gnu.org/licenses/agpl-3.0.txt";
            hash = "sha256-DZak/2itbUtvHzD3E7GNUYSRK6jdOJ+GqncQ2weavLA=";
            name = "LICENSE";
          };
        }
      ];
    };
}
