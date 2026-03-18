{
  homeModules ? [ ],
  lib,
  pkgs,
  writeTextFile,
}:
let
  eval = lib.evalModules {
    modules = homeModules ++ [
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
          args.pkgs = pkgs; # inputs.home-manager.inputs.nixpkgs.legacyPackages.${system};
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
  options = flattenOptions "dotfiles" (eval.options.dotfiles or { });
  optionsMarkdown = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: opt:
      let
        default =
          if opt ? defaultText then
            opt.defaultText.text
          else if opt ? default then
            lib.generators.toJSON { } opt.default
          else
            null;
        defaultLine = lib.optionalString (default != null) "* Default: `${default}`\n";
        descriptionLine = lib.optionalString (opt ? description) "* Description: ${opt.description}\n";
        exampleLine =
          lib.optionalString (opt ? example)
            "* Example: `${lib.generators.toJSON { } opt.example}`\n";
        typeLine = lib.optionalString (
          opt ? type && opt.type ? description
        ) "* Type: `${opt.type.description}`";
      in
      ''
        ### `${name}`

        ${defaultLine}${descriptionLine}${exampleLine}${typeLine}
      ''
    ) options
  );
in
writeTextFile {
  meta = {
    description = "Options documentation for the dotfiles module";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
  name = "options.md";
  text = optionsMarkdown;
}
