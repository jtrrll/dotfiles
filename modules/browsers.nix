{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.homeManager.browsers =
    {
      config,
      lib,
      ...
    }:
    {
      options.dotfiles.browsers = {
        brave.enable = lib.mkEnableOption "jtrrll's Brave browser configuration" // {
          default = true;
        };
      };

      config = {
        programs.brave = lib.mkIf config.dotfiles.browsers.brave.enable {
          enable = true;
          extensions = [
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
            { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
            { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock for youtube
            { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
          ];
        };
      };
    };
}
