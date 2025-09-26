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
        users.jtrrll = {pkgs, ...}: {
          jtrrllDotfiles = {
            bat.enable = true;
            browsers.brave.enable = true;
            codeDirectory.enable = true;
            editors = {
              neovim.enable = true;
              vscode.enable = true;
            };
            fileSystem.enable = true;
            gaming.enable = true;
            git.enable = true;
            homeManager.enable = true;
            mediaPlayback.enable = true;
            musicLibrary.enable = true;
            nix.enable = true;
            repeat.enable = true;
            screensavers.enable = true;
            systemInfo.enable = true;
            terminal.enable = true;
            theme = {
              base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              enable = true;
            };
          };
        };
      };
    }
    lenovo-thinkpad-x1
    ./hardware_configuration.nix
    {
      users.users.jtrrll = {
        name = "jtrrll";
        home = "/home/jtrrll";
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
      };
    }
    {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      networking = {
        hostName = "athena";
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
