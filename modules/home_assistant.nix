{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.nixos.homeAssistant = {
    services.home-assistant = {
      enable = true;
      config = { };
    };
  };
}
