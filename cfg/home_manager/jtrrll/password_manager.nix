{
  config,
  lib,
  pkgs,
  ...
}:
let
  bitwardenExtensionId = "nngceckbapebfimnlniiiahkandclblb";
  bitwardenFirefoxId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
  chromiumBrowsers = [
    # keep-sorted start
    "chromium"
    "google-chrome"
    "google-chrome-beta"
    "google-chrome-dev"
    "microsoft-edge"
    "vivaldi"
    # keep-sorted end
  ];
  isProprietaryChrome = browser: lib.hasPrefix "google-chrome" browser;
in
{
  config = lib.mkMerge (
    [
      { programs.rbw.enable = lib.mkDefault true; }
      (lib.mkIf config.programs.rbw.enable {
        programs.rbw.settings = {
          email = "jacksonterrill3@gmail.com";
          pinentry = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;
        };
      })
    ]
    ++ map (
      browser:
      lib.mkIf
        (
          config.programs.${browser}.enable
          && (pkgs.stdenv.hostPlatform.isDarwin || !isProprietaryChrome browser)
        )
        {
          programs.${browser}.extensions = [ { id = bitwardenExtensionId; } ];
        }
    ) chromiumBrowsers
    ++ [
      (lib.mkIf config.programs.librewolf.enable {
        programs.librewolf.policies.ExtensionSettings.${bitwardenFirefoxId} = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
      })
    ]
  );
}
