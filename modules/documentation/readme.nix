{ config, inputs, ... }:
{
  config.perSystem =
    let
      inherit (config.flake) homeModules nixosModules;
      inherit (config) processedFlake;
    in
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      hmLib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" lib;
      stubModules = [
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
            args.pkgs = pkgs;
            check = false;
          };
        }
      ];
      renderValue =
        v:
        if v ? _type && v._type == "literalExpression" then
          v.text
        else if v ? _type && v._type == "literalMD" then
          v.text
        else
          lib.generators.toJSON { } v;
      renderOption =
        opt:
        let
          inherit (opt) name;
          default = if opt ? default then renderValue opt.default else null;
          rawDesc = opt.description or null;
          firstLine = if rawDesc == null then null else lib.head (lib.splitString "\n" (lib.trim rawDesc));
          details = lib.concatStrings [
            (lib.optionalString (firstLine != null) " - ${firstLine}")
            (lib.optionalString (opt ? type && opt.type ? description) " (`${opt.type.description}`)")
            (lib.optionalString (default != null) " (default: `${default}`)")
          ];
        in
        "  - `${name}`${details}";
      filterOpts =
        excludePrefixes:
        lib.filter (opt: !(lib.any (prefix: lib.hasPrefix prefix opt.name) excludePrefixes));
      optionsForModules =
        {
          modules,
          excludePrefixes,
          evalModules ? lib.evalModules,
        }:
        let
          eval = evalModules { inherit modules; };
        in
        filterOpts excludePrefixes (lib.optionAttrSetToDocList eval.options);
      renderModuleOptions =
        opts: if opts == [ ] then "" else lib.concatStringsSep "\n" (map renderOption opts);
      homeModuleOptions =
        moduleName:
        optionsForModules {
          inherit (hmLib) evalModules;
          modules = [ homeModules.${moduleName} ] ++ stubModules;
          excludePrefixes = [
            "_module"
            "programs.__stub"
            "home."
          ];
        };
      nixosModuleOptions =
        moduleName:
        optionsForModules {
          modules = [
            nixosModules.${moduleName}
            {
              config._module = {
                args.pkgs = pkgs;
                check = false;
              };
            }
          ];
          excludePrefixes = [
            "_module"
            "tests"
          ];
        };
      outputsMarkdown =
        let
          isPerSystem =
            name:
            let
              val = processedFlake.${name};
            in
            lib.isAttrs val && val ? ${system};
          outputNames = lib.pipe (lib.attrNames processedFlake) [
            (lib.sort lib.lessThan)
          ];
          describedOutputs = [
            "apps"
            "homeConfigurations"
            "nixosConfigurations"
            "nixosTests"
            "packages"
          ];
          attrNamesFor =
            name:
            let
              val = processedFlake.${name};
            in
            if isPerSystem name then
              let
                perSysVal = val.${system};
                tried = builtins.tryEval (
                  if lib.isDerivation perSysVal then
                    [ ]
                  else if lib.isAttrs perSysVal then
                    lib.attrNames perSysVal
                  else
                    [ ]
                );
              in
              if tried.success then tried.value else [ ]
            else if lib.isAttrs val then
              let
                tried = builtins.tryEval (lib.attrNames val);
              in
              if tried.success then tried.value else [ ]
            else
              [ ];
          formatAttr =
            outputName: attrName:
            let
              optionsMd =
                if outputName == "homeModules" then
                  renderModuleOptions (homeModuleOptions attrName)
                else if outputName == "nixosModules" then
                  renderModuleOptions (nixosModuleOptions attrName)
                else
                  "";
              description =
                if lib.elem outputName describedOutputs then
                  let
                    val =
                      if isPerSystem outputName then
                        processedFlake.${outputName}.${system}.${attrName}
                      else
                        processedFlake.${outputName}.${attrName};
                  in
                  if lib.isDerivation val then
                    val.meta.description or null
                  else if lib.isAttrs val && val ? config.meta.description then
                    val.config.meta.description
                  else if lib.isAttrs val && val ? meta && lib.isAttrs val.meta then
                    val.meta.description or null
                  else
                    null
                else
                  null;
              descSuffix = lib.optionalString (description != null) " - ${description}";
            in
            if optionsMd == "" then
              "- `${attrName}`${descSuffix}"
            else
              "- `${attrName}`${descSuffix}\n${optionsMd}";
          formatSection =
            name:
            let
              attrs = lib.sort lib.lessThan (attrNamesFor name);
            in
            if attrs == [ ] then
              "### `${name}`"
            else
              "### `${name}`\n\n${lib.concatStringsSep "\n\n" (map (formatAttr name) attrs)}";
        in
        lib.concatStringsSep "\n\n" (map formatSection outputNames);
    in
    {
      config = {
        apps.update-demo =
          let
            pkg = pkgs.callPackage (
              {
                bashInteractive,
                uutils-coreutils-noprefix,
                vhs,
                writeShellApplication,
              }:
              writeShellApplication rec {
                meta = {
                  inherit (vhs.meta) platforms;
                  description = "Updates the demo gif";
                  mainProgram = name;
                };
                name = "update-demo";
                runtimeInputs = [
                  bashInteractive
                  uutils-coreutils-noprefix
                  vhs
                ];
                text = ''
                  cat <<EOF | vhs -
                  Output demo.gif

                  Set FontFamily "Hack Nerd Font Mono"
                  Set FontSize 28
                  Set Padding 10
                  Set Theme "catppuccin-frappe"
                  Set TypingSpeed 100ms

                  Set Width 800
                  Set Height 450

                  Require nix

                  Sleep 1s

                  Type "nix run github:jtrrll/dotfiles home"
                  Sleep 1s
                  Enter

                  Wait+Screen /Select/
                  Sleep 2s
                  Down
                  Sleep 500ms
                  Up
                  Sleep 500ms
                  Enter

                  Sleep 5s
                  EOF
                  printf "Updated demo.gif\n"
                '';
              }
            ) { };
          in
          {
            meta.description = pkg.meta.description;
            program = pkg;
            type = "app";
          };
        files = {
          file."README.md".text = ''
            # ~/.dotfiles

            <!-- markdownlint-disable MD013 -->
            ![CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&label=ci&logo=github)
            ![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=license&logo=googledocs&logoColor=white)
            <!-- markdownlint-enable MD013 -->

            My dotfiles collection for configuring frequently used programs.
            Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

            ![Demo](./demo.gif)

            ## Usage

            1. [Install Nix](https://zero-to-nix.com/start/install)
            2. Activate a configuration interactively by running the following:

                ```sh
                nix run github:jtrrll/dotfiles home
                ```

            ## Outputs

            ${outputsMarkdown}
          '';
          writer.app = true;
        };
      };
    };
}
