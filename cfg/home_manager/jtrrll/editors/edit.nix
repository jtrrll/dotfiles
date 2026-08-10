{ lib, ... }:
{
  config.programs.edit.enable = lib.mkDefault true;
}
