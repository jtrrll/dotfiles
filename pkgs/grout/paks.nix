{ src }:
{
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
