{lib, ...}: {
  imports = [
    ./bonsai.nix
    ./matrix.nix
  ];

  options.dotfiles.screensavers = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable screensavers.";
      example = false;
      type = lib.types.bool;
    };
  };
}
