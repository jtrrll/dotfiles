{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages.options = let
      eval = lib.evalModules {
        modules = [
          self.homeManagerModules.dotfiles
          {dotfiles.username = "\${config.dotfiles.username}";}
          {options.programs.__stub = lib.mkSinkUndeclaredOptions {};}
          {
            config._module = {
              check = false;
              lib.stylix = {};
              stylix.targets = {};
            };
          }
        ];
      };
      flattenOptions = prefix: opts:
        lib.foldlAttrs (
          acc: name: opt: let
            fullName =
              if prefix == ""
              then name
              else "${prefix}.${name}";
            result =
              if opt ? type
              then {"${fullName}" = opt;}
              else flattenOptions fullName opt;
          in
            acc // result
        ) {}
        opts;
      options = flattenOptions "dotfiles" eval.options.dotfiles;
      optionsMarkdown = lib.concatStringsSep "\n" (lib.mapAttrsToList
        (
          name: opt: let
            defaultLine = lib.optionalString (opt ? default) "* Default: `${builtins.toJSON opt.default}`\n";
            descriptionLine = lib.optionalString (opt ? description) "* Description: ${opt.description}\n";
            exampleLine = lib.optionalString (opt ? example) "* Example: `${builtins.toJSON opt.example}`\n";
            typeLine = lib.optionalString (opt ? type && opt.type ? description) "* Type: `${opt.type.description}`";
          in ''
            ### `${name}`

            ${defaultLine}${descriptionLine}${exampleLine}${typeLine}
          ''
        )
        options);
    in
      pkgs.writeTextFile {
        meta = {
          description = "Options documentation for the dotfiles module";
          homepage = "https://github.com/jtrrll/dotfiles";
          license = lib.licenses.mit;
        };
        name = "options.md";
        text = optionsMarkdown;
      };
  };
}
