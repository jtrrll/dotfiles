{
  nixosHardwareModules,
  ...
}:
{
  imports = [
    nixosHardwareModules.raspberry-pi-3
  ];

  home-manager = {
    users.jtrrll = {
      programs = {
        beets.enable = false;
        brave.enable = false;
        prismlauncher.enable = false;
        retroarch.enable = false;
        vesktop.enable = false;
        zed-editor.enable = false;
      };
      services.musicLibrary.enable = false;
    };
  };

  users.users.jtrrll = {
    enable = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

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
