{
  lenovo-thinkpad-x1,
  nixosModules,
  nixosSystem,
}:
nixosSystem {
  system = "x86_64-linux";
  modules = nixosModules ++ [
    {
      dotfiles = {
        gaming.enable = true;
      };
      home-manager = {
        sharedModules = [ { home.stateVersion = "25.05"; } ];
        users.jtrrll =
          { pkgs, ... }:
          {
            home.sessionVariables = {
              EDITOR = "nvim";
              VISUAL = "zeditor";
            };
            dotfiles.theme.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
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
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    }
    {
      boot.loader = {
        systemd-boot = {
          configurationLimit = 2;
          enable = true;
        };
        efi.canTouchEfiVariables = true;
      };

      networking = {
        hostName = "athena";
        networkmanager.enable = true;
      };

      programs.xwayland.enable = true;

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

        openssh.enable = true;

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
