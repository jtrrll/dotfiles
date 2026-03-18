{
  gum,
  homeConfigurations ? [ ],
  lib,
  nh,
  nixosConfigurations ? [ ],
  replaceVars,
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

  script = replaceVars ./activate.nu {
    HOME_CONFIGURATIONS = homeConfigurationsString;
    NIXOS_CONFIGURATIONS = nixosConfigurationsString;
  };
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
    } (lib.readFile script)
  )
