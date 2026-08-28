{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    { home.packages = [ pkgs.handy ]; }
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      programs.vicinae = {
        extensions = [
          (pkgs.mkRayCastExtension (finalAttrs: {
            name = "handy";
            src =
              pkgs.fetchFromGitHub {
                owner = "raycast";
                repo = "extensions";
                rev = "0e62f7d1cffac7bab0d06caf87c5e85507989804";
                hash = "sha256-pkLtXumdc/2j+t2HyeE4QVPTr2AkHnRN7GmYo3RU410=";
                sparseCheckout = [ "/extensions/handy" ];
              }
              + "/extensions/handy";
            npmDeps = pkgs.fetchNpmDeps {
              name = "handy-npm-deps";
              inherit (finalAttrs) src;
              hash = "sha256-gy4rTgzC53rBDUTIrYwi3r38WRqyOuv628xEmw0qYuo=";
            };
            inherit (pkgs.npmHooks) npmConfigHook;
            installPhase = ''
              runHook preInstall
              mkdir -p "$out"
              cp -r "$HOME/.config/raycast/extensions/"*/. "$out"/
              runHook postInstall
            '';
          }))
        ];
        settings.providers."@mattiacolombomc/handy".preferences.handyBinaryPath = "${pkgs.handy}/bin/handy";
      };
    })
  ];
}
