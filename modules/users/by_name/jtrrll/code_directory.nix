{ lib, ... }:
{
  config.services.codeDirectory.enable = lib.mkDefault true;
}
