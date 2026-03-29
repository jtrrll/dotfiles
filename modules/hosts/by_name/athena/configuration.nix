{
  nixosHardwareModules,
  ...
}:
{
  imports = [
    nixosHardwareModules.lenovo-thinkpad-x1
  ];

  dotfiles.gaming.enable = true;

  users.users.jtrrll = {
    enable = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

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
