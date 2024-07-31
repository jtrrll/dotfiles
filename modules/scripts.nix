{pkgs, ...}: {
  home.packages = [
    (let
      name = "home@latest";
    in
      pkgs.writeShellScriptBin name ''
        if [ "$#" -gt 1 ]; then
          printf "Usage: ${name} <CONFIG>\n" 1>&2
          exit 1
        fi

        CONFIG="$1"
        if [ -n "$CONFIG" ]; then
          CONFIG="#$CONFIG"
        fi

        home-manager switch -b backup --impure --flake github:jtrrll/dotfiles$CONFIG
      '')
  ];
}
