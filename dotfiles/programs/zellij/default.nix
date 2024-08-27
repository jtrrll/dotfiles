{
  args,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.dotfiles.programs.enable {
    programs.zellij = {
      enable = true;
    };

    home.file."layouts" = {
      source = ./layouts;
      target = "${args.homeDirectory}/.config/zellij/layouts";
    };
  };
}
