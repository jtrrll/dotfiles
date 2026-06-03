{
  config.perSystem =
    { pkgs, ... }:
    {
      config.files.file.".github/dependabot.yaml".source =
        let
          yaml = pkgs.formats.yaml { };
          generated = yaml.generate "dependabot.yaml" {
            version = 2;
            updates = [
              {
                package-ecosystem = "github-actions";
                commit-message.prefix = "deps";
                directory = "/";
                labels = [
                  "automated"
                  "dependencies"
                  "github-actions"
                ];
                schedule.interval = "weekly";
              }
              {
                package-ecosystem = "nix";
                commit-message.prefix = "deps";
                directory = "/";
                labels = [
                  "automated"
                  "dependencies"
                ];
                schedule = {
                  interval = "weekly";
                  day = "friday";
                };
                groups = {
                  flake.patterns = [
                    "files"
                    "flake-parts"
                    "import-tree"
                    "justix"
                    "nixpkgs"
                    "treefmt-nix"
                  ];
                  development.patterns = [
                    "devenv"
                  ];
                  home-manager.patterns = [
                    "home-manager"
                    "nixvim"
                    "snekcheck"
                    "stylix"
                  ];
                  nixos.patterns = [
                    "determinate"
                    "disko"
                    "nixos-hardware"
                  ];
                  infrastructure.patterns = [
                    "terranix"
                  ];
                };
              }
            ];
          };
        in
        pkgs.runCommand "dependabot.yaml" { nativeBuildInputs = [ pkgs.yq-go ]; } ''
          yq 'pick(["version", "updates"]) | .updates[] |= pick(["package-ecosystem", "commit-message", "directory", "labels", "schedule", "groups"])' ${generated} > $out
        '';
    };
}
