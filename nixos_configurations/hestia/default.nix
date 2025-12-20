{
  dotfiles,
  homeAssistant,
  nix,
  nixosSystem,
  raspberry-pi-3,
}:
nixosSystem {
  system = "aarch64-linux";
  modules = [
    dotfiles
    homeAssistant
    nix
    {
      home-manager = {
        sharedModules = [ { home.stateVersion = "25.05"; } ];
        users.jtrrll = {
          dotfiles.presets.minimal.enable = true;
        };
      };
    }
    raspberry-pi-3
    ./hardware_configuration.nix
    {
      users.users.jtrrll = {
        name = "jtrrll";
        home = "/home/jtrrll";
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    }
    {
      networking = {
        hostName = "hestia";
        networkmanager.enable = true;
      };

      services = {
        automatic-timezoned.enable = true;

        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "colemak_dh";
          };
        };

        caddy.enable = true;

        openssh.enable = true;
      };

      system.stateVersion = "25.05";
    }
  ];
}
