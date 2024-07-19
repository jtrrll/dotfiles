{
  username,
  homeDirectory,
  ...
}: {
  programs.home-manager.enable = true;
  imports = [
    ./modules/programs
    ./modules/fonts.nix
  ];

  home = {
    stateVersion = "23.11";
    inherit username homeDirectory;
    shellAliases = {
      cat = "bat --paging=never"; # print file (replaces cat)
      cd = "z"; # change directory (replaces cd)
      cdi = "zi"; # change directory with an interactive fuzzy finder
      grep = "batgrep"; # ripgrep with bat as the formatter (replaces grep)
      man = "batman"; # read manual pages with bat as the formatter
    };
  };
}
