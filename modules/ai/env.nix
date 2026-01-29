{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    dotfiles.ai.env = pkgs.buildEnv {
      name = "ai-env";
      paths = config.dotfiles.ai.packages;
    };
  };

  options.dotfiles.ai = {
    env = lib.mkOption {
      type = lib.types.package;
      description = "An environment of packages for use by AI.";
      readOnly = true;
    };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "The set of packages to appear in the AI environment.";
    };
  };
}
