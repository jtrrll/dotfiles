{ config, lib, ... }:
{
  config = {
    services.codeStorage.enable = lib.mkDefault true;
    programs.sessions = {
      enable = lib.mkDefault true;
      # Sessions check out worktrees from the bare repos codeStorage manages.
      codeDirectory = config.services.codeStorage.directory;
    };
  };
}
