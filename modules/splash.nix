{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.splash = pkgs.callPackage (
        {
          lolcat,
          uutils-coreutils-noprefix,
          writeShellApplication,
        }:
        writeShellApplication rec {
          meta = {
            description = "Prints a splash screen.";
            mainProgram = name;
          };
          name = "splash";
          runtimeInputs = [
            lolcat
            uutils-coreutils-noprefix
          ];
          text = ''
            printf "    ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
                ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
                ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
                ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
            ██▓ ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
            ▒▓▒  ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
            ░▒   ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
            ░    ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
              ░     ░        ░ ░                   ░      ░  ░   ░  ░      ░
              ░   ░\n" | lolcat
          '';
        }
      ) { };
    };
}
