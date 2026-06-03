{
  config.perSystem = _: {
    config.pre-commit.settings = {
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
  };
}
