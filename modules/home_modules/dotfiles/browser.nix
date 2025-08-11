{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.browser.enable {
    programs.brave = {
      enable = true;
      extensions = [
        { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock for youtube
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    };
  };

  options.dotfiles.browser = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable the browser configuration.";
      example = false;
      type = lib.types.bool;
    };
  };
}
