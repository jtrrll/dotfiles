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
    programs = {
      alacritty = {
        enable = true;
        settings = {
          env.SHELL = "${config.programs.fish.package}/bin/fish";
          terminal.shell.program = "${config.programs.zellij.package}/bin/zellij";
        };
      };
      ghostty = {
        enable = true;
        installBatSyntax = !pkgs.stdenv.isDarwin;
        installVimSyntax = !pkgs.stdenv.isDarwin;
        settings.command = "${config.programs.zellij.package}/bin/zellij";
      };
    };
  };
}
