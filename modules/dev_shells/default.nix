{
  config = {
    perSystem =
      { config, ... }:
      {
        config.devenv.shells.default =
          { lib, pkgs, ... }:
          {
            enterShell = lib.concatStringsSep "\n" [
              (lib.getExe pkgs.splash)
              config.pre-commit.installationScript
              ''printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"''
            ];

            languages.nix.enable = true;
          };
      };
    touchup.attr.packages.any.attr = {
      # Remove deprecated packages that devenv includes.
      devenv-test.enable = false;
      devenv-up.enable = false;
    };
  };
}
