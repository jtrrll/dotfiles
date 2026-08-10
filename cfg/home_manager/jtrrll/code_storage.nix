{ lib, ... }:
{
  config.services.codeStorage.enable = lib.mkDefault true;
}
