{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "locked";
        show_release_notes = false;
        show_startup_tips = false;
      };
    };

    home.file.zellij-layouts = builtins.addErrorContext "while parsing Zellij layouts" (let
      source = ./layouts;
    in
      assert builtins.all (lib.hasSuffix ".kdl") (builtins.attrNames (builtins.readDir source)); {
        inherit source;
        target = ".config/zellij/layouts";
      });
  };
}
