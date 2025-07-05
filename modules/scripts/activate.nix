{self, ...}: {
  perSystem = {pkgs, ...}: {
    scripts.activate = pkgs.writeShellApplication {
      meta.description = "Activates a home configuration.";
      name = "activate";
      runtimeInputs = [
        pkgs.gum
        pkgs.home-manager
        pkgs.uutils-coreutils-noprefix
      ];
      text = let
        configurations = builtins.attrNames self.homeConfigurations;
      in ''
        if [[ "$#" -eq 1 ]]; then
          config="$1"
        elif [[ "$#" -eq 0 ]]; then
          config=$(printf "%s" "${builtins.concatStringsSep "\n" configurations}" | gum filter)
        else
          echo "Usage: $(basename "$0") <config>"
          exit 1
        fi

        home-manager switch -b bak --flake "$PROJECT_ROOT"#"$config" --impure
      '';
    };
  };
}
