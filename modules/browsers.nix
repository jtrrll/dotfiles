{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.browsers =
    {
      config,
      lib,
      ...
    }:
    {
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

      options.dotfiles.browsers = {
        brave.enable = lib.mkEnableOption "jtrrll's Brave browser configuration";
      };
    };
}
