{
  homeModules,
  lib,
  writeTextFile,
}:
let
  eval = builtins.addErrorContext "while evaluating dotfiles module" lib.evalModules {
    modules = [
      homeModules.default
      {
        options.home = {
          username = lib.mkOption {
            default = "\${config.home.username}";
            type = lib.types.str;
          };
          homeDirectory = lib.mkOption {
            type = lib.types.path;
          };
        };
      }
      { options.programs.__stub = lib.mkSinkUndeclaredOptions { }; }
      {
        config._module = {
          check = false;
          lib.stylix = { };
          stylix.targets = { };
        };
      }
    ];
  };
  flattenOptions =
    prefix: opts:
    lib.foldlAttrs (
      acc: name: opt:
      let
        fullName = if prefix == "" then name else "${prefix}.${name}";
        result = if opt ? type then { "${fullName}" = opt; } else flattenOptions fullName opt;
      in
      acc // result
    ) { } opts;
  options = flattenOptions "jtrrllDotfiles" eval.options.jtrrllDotfiles;
  optionsMarkdown = builtins.addErrorContext "while formatting options as markdown text" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: opt:
        let
          defaultLine = lib.optionalString (opt ? default) "* Default: `${builtins.toJSON opt.default}`\n";
          descriptionLine = lib.optionalString (opt ? description) "* Description: ${opt.description}\n";
          exampleLine = lib.optionalString (opt ? example) "* Example: `${builtins.toJSON opt.example}`\n";
          typeLine = lib.optionalString (
            opt ? type && opt.type ? description
          ) "* Type: `${opt.type.description}`";
        in
        ''
          ### `${name}`

          ${defaultLine}${descriptionLine}${exampleLine}${typeLine}
        ''
      ) options
    )
  );
in
writeTextFile {
  meta = {
    description = "Options documentation for the dotfiles module";
    homepage = "https://github.com/jtrrll/dotfiles";
    license = lib.licenses.mit;
  };
  name = "options.md";
  text = optionsMarkdown;
}
