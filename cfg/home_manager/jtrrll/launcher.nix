{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.vicinae = {
        enable = true;
        extensions =
          let
            vicinaeExtensionsSrc = pkgs.fetchFromGitHub {
              owner = "vicinaehq";
              repo = "extensions";
              rev = "d61bf7b835ebd29c806387f0e013df04dd61a368";
              hash = "sha256-E3ZW5x/hemm6qEIY98fp7DrXiMg7uQdg80wIqcSRGCA=";
            };
          in
          [
            (pkgs.mkVicinaeExtension (finalAttrs: {
              pname = "vicinae-extension-nix";
              version = "0";
              src = "${vicinaeExtensionsSrc}/extensions/nix";
              npmFlags = [ "--legacy-peer-deps" ];
              npmDeps = pkgs.fetchNpmDeps {
                name = "vicinae-extension-nix-npm-deps";
                inherit (finalAttrs) src;
                hash = "sha256-TEyCCDjAtRYX2uH2TpLfe4/hTzyfMiyDhzVdyQXhEus=";
              };
              inherit (pkgs.npmHooks) npmConfigHook;
              postPatch = ''
                substituteInPlace tsconfig.json --replace "../../" "${vicinaeExtensionsSrc}/"
              '';
            }))
          ];
        settings = {
          global_shortcuts = {
            toggle = if pkgs.stdenv.isDarwin then "cmd+space" else "super+space";
          };
        };
      };
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      programs.vicinae.launchd.enable = true;
      # Disable the spotlight hotkey so that vicinae can take its place.
      home.activation.disableSpotlightHotkey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        plist="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
        for id in 64; do
          run /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:$id:enabled false" "$plist" \
            || run /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:$id:enabled bool false" "$plist"
        done
      '';
    })
    (lib.mkIf pkgs.stdenv.isLinux {
      programs.vicinae.systemd.enable = true;
      # GNOME's Mutter compositor doesn't implement vicinae's custom
      # `vicinae-hotkey-v1` Wayland protocol for global shortcuts.
      dconf.settings = {
        # GNOME binds Super+Space to input-source switching by default;
        # clear it so it doesn't conflict with vicinae's toggle below.
        "org/gnome/desktop/wm/keybindings" = {
          switch-input-source = [ ];
          switch-input-source-backward = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae-toggle/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae-toggle" = {
          name = "Toggle Vicinae";
          command = "vicinae toggle";
          binding = "<Super>space";
        };
      };
    })
  ];
}
