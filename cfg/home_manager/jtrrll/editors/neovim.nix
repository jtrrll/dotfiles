{
  pkgs,
  ...
}:
{
  config.home = {
    packages = [ pkgs.neovim ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
