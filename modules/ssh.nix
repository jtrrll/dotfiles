{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.homeManager.ssh =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.dotfiles.ssh;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.ssh = {
          enable = true;
          matchBlocks = {
            "*" = {
              addKeysToAgent = "yes";
            };
            "github-personal" = {
              hostname = "github.com";
              user = "git";
              identitiesOnly = true;
              identityFile = [ "${config.home.homeDirectory}/.ssh/github_personal_id_ed25519" ];
            };
            "github-personal-bot" = {
              hostname = "github.com";
              user = "git";
              identitiesOnly = true;
              identityFile = [ "${config.home.homeDirectory}/.ssh/github_personal_bot_id_ed25519" ];
            };
            "github-work" = {
              hostname = "github.com";
              user = "git";
              identitiesOnly = true;
              identityFile = [ "${config.home.homeDirectory}/.ssh/github_work_id_ed25519" ];
            };
          };
          extraConfig = ''
            UseKeychain yes
          '';
        };
      };

      options.dotfiles.ssh = {
        enable = lib.mkEnableOption "jtrrll's SSH configuration";
      };
    };
}
