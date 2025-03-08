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
      package = pkgs.beets.override {
        pluginOverrides = {
          embedart.enable = true;
          fetchart.enabled = true;
          thumbnails.enabled = true;
        };
      };
      settings = {
        directory = "~/music";
        import = {
          copy = false;
          move = false;
        };
        library = "~/music/library.db";
        plugins = ["embedart" "fetchart" "thumbnails"];
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
