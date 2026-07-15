{
  config = {
    perSystem =
      { lib, ... }:
      {
        config.devenv = {
          modules = [
            {
              containers = lib.mkForce { }; # Workaround to remove containers from flake checks.
            }
          ];
          shells.default =
            { pkgs, ... }:
            {
              enterShell = lib.concatStringsSep "\n" [
                (lib.getExe pkgs.splash)
                ''printf "\033[0;1;36mDEVSHELL ACTIVATED\033[0m\n"''
              ];

              packages = [
                pkgs.rbw
                pkgs.sops
                pkgs.ssh-to-age
              ];

              scripts.sops-with-key = {
                description = "Run sops with the global age key pulled from Bitwarden via rbw.";
                exec = ''
                  set -euo pipefail

                  bitwarden_entry="dotfiles/sops-age-key"

                  age_key="$(
                    ${lib.getExe pkgs.rbw} get --full "$bitwarden_entry" \
                      | ${lib.getExe pkgs.ripgrep} --only-matching --max-count 1 'AGE-SECRET-KEY-[0-9A-Z]+'
                  )"

                  if [ -z "$age_key" ]; then
                    printf 'error: no AGE-SECRET-KEY found in Bitwarden entry "%s"\n' "$bitwarden_entry" >&2
                    exit 1
                  fi

                  SOPS_AGE_KEY="$age_key" ${lib.getExe pkgs.sops} "$@"
                '';
              };

              enterTest = ''
                nix --version
              '';

              git-hooks = {
                default_stages = [ "pre-push" ];
                hooks = {
                  actionlint.enable = true;
                  check-added-large-files = {
                    enable = true;
                    stages = [ "pre-commit" ];
                  };
                  check-json.enable = true;
                  check-yaml.enable = true;
                  deadnix.enable = true;
                  detect-private-keys = {
                    enable = true;
                    stages = [ "pre-commit" ];
                  };
                  end-of-file-fixer.enable = true;
                  flake-checker.enable = true;
                  fmt = {
                    enable = true;
                    entry = "just fmt";
                    name = "fmt";
                    pass_filenames = false;
                  };
                  mixed-line-endings.enable = true;
                  nil.enable = true;
                  no-commit-to-branch = {
                    enable = true;
                    stages = [ "pre-commit" ];
                  };
                  ripsecrets = {
                    enable = true;
                    stages = [ "pre-commit" ];
                  };
                  shellcheck = {
                    enable = true;
                    excludes = [ ".envrc" ];
                  };
                  shfmt.enable = true;
                  statix.enable = true;
                };
              };

              languages.nix.enable = true;
            };
        };
      };
    touchup.attr.packages.any.attr = {
      # Remove deprecated packages that devenv includes.
      devenv-test.enable = false;
      devenv-up.enable = false;
    };
  };
}
