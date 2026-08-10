{
  gum,
  homeConfigurations ? [ ],
  lib,
  nh,
  nixosConfigurations ? [ ],
  rootPath ? ".",
  writers,
}:
let
  homeConfigurationsString =
    assert lib.isList homeConfigurations && lib.all lib.isString homeConfigurations;
    lib.concatStringsSep "\n" homeConfigurations;

  nixosConfigurationsString =
    assert lib.isList nixosConfigurations && lib.all lib.isString nixosConfigurations;
    lib.concatStringsSep "\n" nixosConfigurations;

  scriptText =
    builtins.replaceStrings
      [ "@HOME_CONFIGURATIONS@" "@NIXOS_CONFIGURATIONS@" ]
      [ homeConfigurationsString nixosConfigurationsString ]
      (lib.readFile ./activate.nu);
in
lib.addMetaAttrs
  {
    description = "Activates a home or NixOS configuration";
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  }
  (
    writers.writeNuBin "activate" {
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath [
          gum
          nh
        ])
        "--set"
        "NH_FLAKE"
        "${rootPath}"
      ];
    } scriptText
  )
