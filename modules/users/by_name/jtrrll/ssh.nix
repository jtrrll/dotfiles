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
        extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
          UseKeychain yes
        '';

        matchBlocks."*" = {
          addKeysToAgent = "yes";
        };
        includes = [ "${config.home.homeDirectory}/.ssh/hosts/*" ];
      };
    })
  ];
}
