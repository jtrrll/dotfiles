{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    scripts.lint = pkgs.writeShellApplication {
      meta.description = "Lints the project.";
      name = "lint";
      runtimeInputs = [
        inputs.snekcheck.packages.${system}.snekcheck
      ];
      text = ''
        snekcheck --fix "$PROJECT_ROOT" && \
        nix fmt "$PROJECT_ROOT" -- --quiet
      '';
    };
  };
}
