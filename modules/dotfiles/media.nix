{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.media.enable {
    home.packages =
      if pkgs.stdenv.isDarwin
      then []
      else [pkgs.vlc];
    programs.beets = {
      enable = true;
      settings = {
        directory = "~/music";
        import = {
          copy = false;
          move = false;
        };
        library = "~/music/library.db";
        plugins = ["autobpm" "badfiles" "embedart" "fetchart" "fish" "fuzzy" "lastgenre" "lyrics" "thumbnails" "types"];
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
