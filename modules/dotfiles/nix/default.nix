{lib, ...}: {
  imports = [
    ./conf.nix
    ./garbage_collection.nix
  ];

  options.dotfiles.nix = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the Nix configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
