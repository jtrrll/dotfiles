{ lib, ... }:
{
  config = lib.mkMerge [
    { services.ollama.enable = lib.mkDefault true; }
  ];
}
