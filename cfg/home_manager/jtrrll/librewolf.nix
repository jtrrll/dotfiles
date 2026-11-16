{ config, lib, ... }:
let
  mkExtension = slug: {
    installation_mode = "force_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  };
in
{
  config = lib.mkMerge [
    { programs.librewolf.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.librewolf.enable {
      programs.librewolf.policies.ExtensionSettings = {
        "webextension@metamask.io" = mkExtension "ether-metamask";
        "sponsorBlocker@ajay.app" = mkExtension "sponsorblock";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = mkExtension "vimium-ff";
      };
    })
  ];
}
