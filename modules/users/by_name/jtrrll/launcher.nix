{
  lib,
  options,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    {
      programs.vicinae = {
        enable = true;
        extensions = [

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
        for id in 60 61; do
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
    (lib.mkIf (options ? stylix) {
      stylix.targets.vicinae.opacity.override = {
        popups = 0.95;
      };
    })
  ];
}
