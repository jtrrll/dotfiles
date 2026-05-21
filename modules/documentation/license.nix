{ inputs, ... }:
{
  imports = [ inputs.files.flakeModules.default ];

  config.perSystem =
    { config, pkgs, ... }:
    {
      config = {
        devenv.modules = [ { packages = [ config.files.writer.drv ]; } ];
        files.files = [
          {
            path_ = "LICENSE";
            drv = pkgs.runCommand "LICENSE" { } ''
              cp ${./agpl_3.0.txt} $out
            '';
          }
        ];
      };
    };
}
