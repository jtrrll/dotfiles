{
  dotfiles.gaming.enable = true;
  home-manager = {
    users.jtrrll =
      { pkgs, ... }:
      {
        dotfiles.theme = {
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
          enable = true;
        };
      };
  };

  users.users.jtrrll = {
    enable = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

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

  programs.xwayland.enable = true;

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
