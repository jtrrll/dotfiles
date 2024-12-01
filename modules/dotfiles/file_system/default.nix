{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    xdg.enable = true;
  };

  imports = [
    ./code.nix
    ./navigation.nix
    ./operations.nix
  ];

  options.dotfiles.file-system = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the file-system configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
