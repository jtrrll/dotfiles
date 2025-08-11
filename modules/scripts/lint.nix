{
  snekcheck,
  writeShellApplication,
}:
writeShellApplication {
  meta.description = "Lints the project.";
  name = "lint";
  runtimeInputs = [ snekcheck ];
  text = ''
    find "$PROJECT_ROOT" \
      ! -path "$PROJECT_ROOT/.*" \
      -exec snekcheck --fix {} +
    nix fmt "$PROJECT_ROOT" -- --quiet
  '';
}
