{ src }:
{
  muos = {
    name = "muos";
    label = "muOS";
    appDir = "Grout";
    launchSource = "${src}/scripts/muOS/mux_launch.sh";
    launchDest = "Grout/mux_launch.sh";
    assets = [
      {
        src = "${src}/scripts/muOS/resources";
        dest = "resources";
      }
    ];
    # muOS installs a `.muxapp`, which is a zip of the app directory.
    package = workdir: out: ''
      (cd "${workdir}" && zip -qr "${out}/Grout.muxapp" Grout)
    '';
  };

  rocknix = {
    name = "rocknix";
    label = "ROCKNIX";
    appDir = "Grout";
    launchSource = "${src}/scripts/ROCKNIX/Grout.sh";
    # ROCKNIX keeps the launch script beside (not inside) the app directory.
    launchDest = "Grout.sh";
    assets = [
      {
        src = "${src}/scripts/ROCKNIX/logo.png";
        dest = "logo.png";
      }
    ];
    package = workdir: out: ''
      cp -R "${workdir}/." "${out}/"
    '';
  };
}
