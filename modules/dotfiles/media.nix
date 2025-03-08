{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.media.enable {
    home.packages = [pkgs.vlc];
    programs.beets = {
      enable = true;
      settings = {
        directory = "~/music";
        import = {
          copy = false;
          move = false;
        };
        library = "~/music/library.db";
      };
    };
  };

  options.dotfiles.media = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the media configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
