{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "romm-frontend";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = finalAttrs.version;
    hash = "sha256-/HOY/N5ykqRBw5IPlO4gJGyrZhPeKMXeDT2/pBSrUhs=";
  };

  sourceRoot = "${finalAttrs.src.name}/frontend";

  npmDepsHash = "sha256-t76GSbSlRh3raClqRFOtCI5bcdpuRhXGmJG1R2+rSZI=";

  makeCacheWritable = true;

  # The app is served as static assets; only the build output is needed.
  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Static frontend assets for RomM";
    homepage = "https://romm.app";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
