{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.jtrrllDotfiles.nix.enable {
    home.file.nix-conf = {
      text = ''
        extra-experimental-features = flakes nix-command no-url-literals
      '';
      target = ".config/nix/nix.conf";
    };
    nix.gc = {
      automatic = true;
      frequency = "monthly";
    };
  };

  options.jtrrllDotfiles.nix = {
    enable = lib.mkEnableOption "jtrrll's Nix configuration";
  };
}
