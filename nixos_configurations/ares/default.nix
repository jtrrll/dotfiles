{
  dotfiles,
  nixosSystem,
}:
nixosSystem {
  system = "x86_64-linux";
  modules = [
    dotfiles
    {
      home-manager = {
        sharedModules = [ { home.stateVersion = "25.05"; } ];
        useGlobalPkgs = true;
        useUserPackages = true;
        users.jtrrll = { };
      };
    }
    ./hardware_configuration.nix
    {
      users.users.jtrrll = {
        name = "jtrrll";
        groups = {
          "networkmanager" = { };
          "wheel" = { };
        };
        home = "/home/jtrrll";
        isNormalUser = true;
      };
    }
    {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      networking = {
        hostName = "ares";
        networkmanager.enable = true;
      };

      services = {
        automatic-timezoned.enable = true;

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "colemak_dh";
          };
        };

        printing.enable = true;

        pipewire = {
          enable = true;
          pulse.enable = true;
        };
      };

      system.stateVersion = "25.05";
    }
  ];
}
