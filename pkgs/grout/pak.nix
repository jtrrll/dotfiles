{
  lib,
  stdenvNoCC,
  patchelf,
  grout,
  SDL2_gfx,
  spec,
}:
let
  # Loader path on the target rootfs; the binary is repointed here so it runs
  # without a Nix store. Overridable per firmware via `spec.loader`.
  loader = spec.loader or "/lib/ld-linux-aarch64.so.1";
in
stdenvNoCC.mkDerivation {
  pname = "grout-pak-${spec.name}";
  inherit (grout) version;

  inherit (grout) src;

  nativeBuildInputs = [
    patchelf
  ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    workdir="$(mktemp -d)"
    appdir="$workdir/${spec.appDir}"
    mkdir -p "$appdir/lib"

    install -Dm755 ${grout}/bin/grout "$appdir/grout"
    patchelf --set-interpreter ${loader} --set-rpath '$ORIGIN/lib' "$appdir/grout"

    for so in ${lib.getLib SDL2_gfx}/lib/libSDL2_gfx*.so*; do
      [ -e "$so" ] && cp -aL "$so" "$appdir/lib/" || true
    done

    cp ${spec.launchSource} "$workdir/${spec.launchDest}"
    ${lib.concatMapStringsSep "\n" (a: ''cp -R ${a.src} "$appdir/${a.dest}"'') spec.assets}

    chmod -R u+w "$workdir"
    chmod a+x "$appdir/grout" "$workdir/${spec.launchDest}"

    mkdir -p "$out"
    ${spec.package "$workdir" "$out"}

    runHook postInstall
  '';

  meta = {
    description = "RomM grout client packaged as a ${spec.label} app";
    homepage = "https://grout.romm.app/";
    license = lib.licenses.mit;
    platforms = [ "aarch64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
