{
  homeDirectory,
  username,
  ...
}: {
  home = {
    inherit homeDirectory username;
    shellAliases = {
      cat = "bat --paging=never"; # print file (replaces cat)
      cd = "z"; # change directory (replaces cd)
      cdi = "zi"; # change directory with an interactive fuzzy finder
      grep = "batgrep"; # ripgrep with bat as the formatter (replaces grep)
      man = "batman"; # read manual pages with bat as the formatter
    };
    stateVersion = "23.11";
  };

  imports = [
    ./modules/programs
    ./modules/fonts.nix
  ];

  programs.home-manager.enable = true;
}
