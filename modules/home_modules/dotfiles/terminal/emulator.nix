{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    home.sessionVariables = {
      SHELL = "${config.programs.fish.package}/bin/fish";
    };
    programs.ghostty = {
      enable = true;
      installBatSyntax = !pkgs.stdenv.isDarwin;
      installVimSyntax = !pkgs.stdenv.isDarwin;
      settings = {
        auto-update = "off";
        command = "${config.programs.zellij.package}/bin/zellij";
      };
    };
  };
}
