{
  rootPath,
  snekcheck,
  writeShellApplication,
}:
writeShellApplication rec {
  meta = {
    description = "Lints the project.";
    mainProgram = name;
  };
  name = "lint";
  runtimeInputs = [ snekcheck ];
  text = ''
    find "${rootPath}" \
      ! -path "${rootPath}/.*" \
      -exec snekcheck --fix {} +
    nix fmt "${rootPath}" -- --quiet
  '';
}
