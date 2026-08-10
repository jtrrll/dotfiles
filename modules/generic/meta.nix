{ lib, ... }:
{
  options.meta = {
    description = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "A custom configuration for a specific context";
      description = "A short description of this configuration.";
    };

    tags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "workstation" ];
      description = "Strings used to categorize this configuration.";
    };
  };
}
