{lib, ...}: {
  imports = [
    ./list.nix
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
