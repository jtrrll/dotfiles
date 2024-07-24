{
  homeDirectory,
  username,
  ...
}: {
  home = {
    inherit homeDirectory username;
    stateVersion = "23.11";
  };

  imports = [
    ./modules
    {_module.args = import ./constants.nix;}
  ];

  programs.home-manager.enable = true;
}
