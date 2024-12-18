{lib, ...}: {
  imports = [
    ./kanata.nix
  ];

  options.dotfiles.input = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the input configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
