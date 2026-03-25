{ config, lib, ... }:
{
  config = lib.mkMerge [
    { programs.brave.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.brave.enable {
      programs.brave.extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock for youtube
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    })
  ];
}
