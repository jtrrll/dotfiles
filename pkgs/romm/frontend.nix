{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "romm-frontend";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = finalAttrs.version;
    hash = "sha256-1LUWXt89lXId32RFDVV4wOkrPwPtnFVVKEnycAS/Nrg=";
  };

  sourceRoot = "${finalAttrs.src.name}/frontend";

  npmDepsHash = "sha256-p8v5LcBSnKt+UC8JwnzU0gdmE4AQk7YsHIxJ5C26NEc=";

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
