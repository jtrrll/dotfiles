{self, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    scripts.update-docs = pkgs.writeShellApplication {
      meta.description = "Updates project documentation in the README.";
      name = "update-docs";
      runtimeInputs = [
        pkgs.bashInteractive
        pkgs.gawk
        pkgs.uutils-coreutils-noprefix
        pkgs.vhs
      ];
      text = ''
        awk '/<!-- BEGIN OPTIONS -->/{flag=1;print;system("cat ${self.packages.${system}.options}");next}/<!-- END OPTIONS -->/{flag=0} !flag' README.md > README.tmp
        mv README.tmp README.md
        printf "Updated README.md with options documentation\n"

        cat <<EOF | vhs -
        Output demo.gif

        Set FontFamily "Hack Nerd Font Mono"
        Set FontSize 28
        Set Padding 10
        Set Theme "catppuccin-frappe"
        Set TypingSpeed 100ms

        Set Width 800
        Set Height 450

        Require nix

        Sleep 1s

        Type "nix run github:jtrrll/dotfiles"
        Sleep 1s
        Enter

        Wait+Screen /Select/
        Sleep 2s
        Up
        Sleep 500ms
        Down
        Sleep 500ms
        Enter

        Sleep 5s
        EOF
        printf "Updated demo.gif\n"
      '';
    };
  };
}
