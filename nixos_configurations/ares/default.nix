{
  dotfiles,
  nix,
  nixosSystem,
}:
nixosSystem {
  system = "x86_64-linux";
  modules = [
    dotfiles
    nix
    {
      home-manager = {
        sharedModules = [ { home.stateVersion = "25.05"; } ];
        users.jtrrll =
          { pkgs, ... }:
          {
            home.sessionVariables = {
              EDITOR = "nvim";
              VISUAL = "zeditor";
            };
            dotfiles = {
              ai.enable = true;
              bat.enable = true;
              browsers.brave.enable = true;
              codeDirectory.enable = true;
              editors = {
                neovim.enable = true;
                zed.enable = true;
              };
              fileSystem.enable = true;
              gaming.enable = true;
              git.enable = true;
              homeManager.enable = true;
              musicLibrary.enable = true;
              nix.enable = true;
              repeat.enable = true;
              screensavers.enable = true;
              systemInfo.enable = true;
              terminal.enable = true;
              theme = {
                enable = true;
                base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              };
            };
          };
      };
    }
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
      boot = {
        binfmt.emulatedSystems = [ "aarch64-linux" ]; # For building ARM packages
        loader = {
          systemd-boot = {
            configurationLimit = 2;
            enable = true;
          };
          efi.canTouchEfiVariables = true;
        };
      };

      hardware = {
        amdgpu.initrd.enable = true;
        enableRedistributableFirmware = true;
      };

      networking = {
        hostName = "ares";
        networkmanager.enable = true;
      };

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
        };
        xwayland.enable = true;
      };

      services = {
        automatic-timezoned.enable = true;

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        xserver = {
          enable = true;
          videoDrivers = [ "amdgpu" ];
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
