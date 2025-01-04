{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.input.enable {
    home = {
      file.kanata-config = {
        target = ".config/kanata/kanata.kbd";
        text = ''
          (defcfg
            process-unmapped-keys yes
          )

          (defsrc
                q w e r t y u i o p
            caps a s d f g h j k l ;
                  z x c v b n m
          )

          (defalias
            cap (tap-hold-press 200 200 esc (layer-while-held arrows))
          )

          (deflayer colemak-dh
               _ _ f p b j l u y ;
            @cap _ r s t g m n e i o
                 x c d _ z k h
          )

          (deflayermap (arrows)
            j left
            k down
            l up
            ; right
          )
        '';
      };
      packages = [
        (pkgs.writeShellApplication
          {
            name = "keyboard";
            # TODO: Install package on Darwin (macOS) once kanata fixes its build.
            runtimeInputs =
              if pkgs.stdenv.isLinux
              then [pkgs.kanata]
              else [];
            text = ''
              if [[ "$#" -ne 0 ]]; then
                echo "Usage: $(basename "$0")"
                exit 1
              fi

              kanata --cfg "${config.home.homeDirectory}/${config.home.file.kanata-config.target}"
            '';
          })
      ];
    };
    # TODO: Run kanata at startup.
  };
}
