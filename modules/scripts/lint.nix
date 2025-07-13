{
  snekcheck,
  writeShellApplication,
}:
writeShellApplication {
  meta.description = "Lints the project.";
  name = "lint";
  runtimeInputs = [snekcheck];
  text = ''
    snekcheck --fix "$PROJECT_ROOT" && \
    nix fmt "$PROJECT_ROOT" -- --quiet
  '';
}
