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
            h left
            j down
            k up
            l right
          )
        '';
      };
      # TODO: Install package on Darwin (macOS) once kanata fixes its build.
      packages = lib.mkIf pkgs.stdenv.isLinux [
        pkgs.kanata
      ];
    };
    # TODO: Run kanata at startup.
  };
}
