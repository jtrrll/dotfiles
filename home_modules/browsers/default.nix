{
  config,
  lib,
  ...
}:
{
  config = {
    programs.brave = lib.mkIf config.jtrrllDotfiles.browsers.brave.enable {
      enable = true;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock for youtube
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    };
  };

  options.jtrrllDotfiles.browsers = {
    brave.enable = lib.mkEnableOption "jtrrll's Brave browser configuration";
  };
}
