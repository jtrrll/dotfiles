{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.nix.enable {
    home.file.nix-conf = {
      text = ''
        extra-experimental-features = flakes nix-command no-url-literals
      '';
      target = "${config.dotfiles.homeDirectory}/.config/nix/nix.conf";
    };
  };
}