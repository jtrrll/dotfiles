{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.nix.enable {
    nix.gc = {
      automatic = true;
      frequency = "monthly";
    };
  };
}
