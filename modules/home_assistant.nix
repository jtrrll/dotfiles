{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.nixos.homeAssistant = {
    services.home-assistant = {
      enable = true;
      config = { };
    };
  };
}
