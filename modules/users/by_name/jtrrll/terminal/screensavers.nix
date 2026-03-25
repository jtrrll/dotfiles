{ lib, ... }:
{
  config.programs = {
    bonsai.enable = lib.mkDefault true;
    matrix.enable = lib.mkDefault true;
  };
}
