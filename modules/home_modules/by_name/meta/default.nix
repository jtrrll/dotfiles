{ lib, ... }:
{
  options.meta.description = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "A short description of this configuration.";
  };
}
