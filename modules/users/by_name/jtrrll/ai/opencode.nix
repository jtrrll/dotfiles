{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.mkMerge [
    { programs.opencode.enable = lib.mkDefault true; }
    (lib.mkIf config.programs.opencode.enable {
      programs.opencode = {
        enableMcpIntegration = true;
        settings.theme = "system";
      };
    })
    (lib.mkIf (options ? stylix) { stylix.targets.opencode.enable = false; })
  ];
}
