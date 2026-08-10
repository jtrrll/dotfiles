{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.beets.enable = lib.mkDefault true;
      services.musicLibrary.enable = lib.mkDefault true;
    }
    (lib.mkIf config.programs.beets.enable {
      home.packages = [ pkgs.ffmpeg ];
      programs.beets.settings = {
        plugins = [
          "autobpm"
          "badfiles"
          "convert"
          "embedart"
          "fetchart"
          "fish"
          "fuzzy"
          "lastgenre"
          "lyrics"
          "musicbrainz"
          "thumbnails"
          "types"
        ];
        lyrics.synced = true;
      };
    })
  ];
}
