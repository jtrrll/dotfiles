{
  programs.git = {
    enable = true;
    extraConfig = {
      core.editor = "vim";
      fetch.prune = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      user = {
        name = "Jackson Terrill";
        useConfigOnly = true; # require an email to be defined in local .gitconfig
      };
    };
  };
}
