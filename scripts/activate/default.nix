{
  homeConfigurations ? [ ],
  nixosConfigurations ? [ ],
  gum,
  home-manager,
  lib,
  nixos-rebuild,
  replaceVars,
  rootPath,
  uutils-coreutils-noprefix,
  writers,
}:
let
  homeConfigurationsString =
    assert builtins.isList homeConfigurations && builtins.all builtins.isString homeConfigurations;
    builtins.concatStringsSep "\n" homeConfigurations;

  nixosConfigurationsString =
    assert builtins.isList nixosConfigurations && builtins.all builtins.isString nixosConfigurations;
    builtins.concatStringsSep "\n" nixosConfigurations;

  script = replaceVars ./activate.nu {
    HOME_CONFIGURATIONS = homeConfigurationsString;
    NIXOS_CONFIGURATIONS = nixosConfigurationsString;
    ROOT_PATH = rootPath;
  };
in
(writers.writeNuBin "activate" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      gum
      home-manager
      nixos-rebuild
      uutils-coreutils-noprefix
    ])
  ];
} (lib.readFile script)).overrideAttrs
  (oldAttrs: {
    meta = (oldAttrs.meta or { }) // {
      description = "Activates a home or NixOS configuration.";
    };
  })
