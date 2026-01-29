{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      package =
        let
          basePkg = pkgs.claude-code;
        in
        pkgs.runCommand "${basePkg.name}-wrapped"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
          }
          ''
            mkdir -p $out/bin
            makeWrapper ${lib.getExe basePkg} $out/bin/claude \
              --prefix PATH : ${config.dotfiles.ai.env}/bin
          '';

      agentsDir = ./agents;
      rulesDir = ./rules;
    };
  };
}
