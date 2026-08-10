{ lib }:
{
  lib = {
    modules = import ./modules.nix { inherit lib; };
    strings = import ./strings.nix { inherit lib; };
  };

  tests = {
    strings = import ./strings_tests.nix { inherit lib; };
  };
}
