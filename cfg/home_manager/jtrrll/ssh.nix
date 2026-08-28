{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { programs.ssh.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.ssh.enable {
      programs.ssh = {
        enableDefaultConfig = false;
        extraConfig = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
          UseKeychain yes
        '';

        settings."*" = {
          AddKeysToAgent = "yes";
        };
        includes = [ "${config.home.homeDirectory}/.ssh/hosts/*" ];
      };
    })
  ];
}
