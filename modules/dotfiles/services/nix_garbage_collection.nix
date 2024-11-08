{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.services.nix-garbage-collection.enable {
    nix.gc = {
      automatic = true;
      frequency = "monthly";
    };
  };

  options.dotfiles = {
    services.nix-garbage-collection = {
      enable = lib.mkOption {
        default = true;
        description = "Whether to enable automatic Nix garbage collection.";
        example = false;
        type = lib.types.bool;
      };
    };
  };
}
