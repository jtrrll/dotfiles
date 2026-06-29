{
  lib,
  stdenv,
  systemd,
  writeShellApplication,
}:
writeShellApplication rec {
  meta = {
    description = "Prevents system sleep while a command runs";
    mainProgram = name;
    platforms = lib.platforms.unix;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
  name = "keep-awake";
  runtimeInputs = lib.optional stdenv.isLinux systemd;
  text =
    if stdenv.isDarwin then
      ''
        exec caffeinate -dims "$@"
      ''
    else
      ''
        exec systemd-inhibit --what=idle:sleep --who=keep-awake --why="Running: $*" "$@"
      '';
}
