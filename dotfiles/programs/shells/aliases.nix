{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    home.shellAliases = {
      cat = "bat --paging=never"; # print file (replaces cat)
      cd = "z"; # change directory (replaces cd)
      cdi = "zi"; # change directory with an interactive fuzzy finder
      grep = "batgrep"; # ripgrep with bat as the formatter (replaces grep)
      man = "batman"; # read manual pages with bat as the formatter
    };
  };
}
