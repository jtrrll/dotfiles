{
  dotfiles,
  nixosSystem,
  raspberry-pi-3,
}:
nixosSystem {
  system = "aarch64-linux";
  modules = [
    dotfiles
    {
      home-manager = {
        sharedModules = [ { home.stateVersion = "25.05"; } ];
        useGlobalPkgs = true;
        useUserPackages = true;
        users.jtrrll = {
          jtrrllDotfiles = {
            bat.enable = true;
            browsers.brave.enable = true;
            codeDirectory.enable = true;
            editors.neovim.enable = true;
            fileSystem.enable = true;
            git.enable = true;
            homeManager.enable = true;
            nix.enable = true;
            systemInfo.enable = true;
            terminal.enable = true;
          };
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
