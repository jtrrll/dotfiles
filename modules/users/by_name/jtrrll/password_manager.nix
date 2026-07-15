{
  config,
  lib,
  pkgs,
  ...
}:
let
  bitwardenExtensionId = "nngceckbapebfimnlniiiahkandclblb";
  chromiumBrowsers = [
    # keep-sorted start
    "brave"
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
          pinentry = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;
        };
      })
    ]
    ++ map (
      browser:
      lib.mkIf
        (config.programs.${browser}.enable && (pkgs.stdenv.isDarwin || !isProprietaryChrome browser))
        {
          programs.${browser}.extensions = [ { id = bitwardenExtensionId; } ];
        }
    ) chromiumBrowsers
  );
}
