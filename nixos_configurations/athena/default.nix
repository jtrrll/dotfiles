{
  dotfiles,
  lenovo-thinkpad-x1,
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
      };
    }
    lenovo-thinkpad-x1
    ./hardware_configuration.nix
    {
      users.users.jtrrll = {
        name = "jtrrll";
        home = "/home/jtrrll";
        isNormalUser = true;
      };
    }
    {
      # Bootloader
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # Networking
      networking = {
        hostName = "athena";
        networkmanager.enable = true;
      };

      services = {
        # Time zone
        automatic-timezoned.enable = true;

        # GNOME Desktop Environment
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        # X11
        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "colemak_dh";
          };
        };

        # CUPS printing
        printing.enable = true;

        # Sound
        pipewire = {
          enable = true;
          pulse.enable = true;
        };
      };

      system.stateVersion = "25.05";
    }
  ];
}
