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

  # vite build omits the static `assets/` tree, merge it in for a static deployment.
  installPhase = ''
    runHook preInstall
    cp -r dist $out
    mkdir -p $out/assets
    cp -r assets/. $out/assets/
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
