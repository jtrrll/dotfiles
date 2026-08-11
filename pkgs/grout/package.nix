{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_gfx,
  libx11,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "grout";
  version = "5.0.0.0";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "grout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oAYS2ChKVSK0uOmE/wiCqBMJg+CUS7YWKGr78hkTGo4=";
  };

  vendorHash = "sha256-earNKxaG8FCkBo5qQWK4ismu+PznPph+asgMg6jRTlc=";

  subPackages = [ "app" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_gfx
    libx11
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL2_image}/include/SDL2"
    "-I${lib.getDev SDL2_ttf}/include/SDL2"
    "-I${lib.getDev SDL2_gfx}/include/SDL2"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X grout/version.Version=${finalAttrs.version}"
    "-X grout/version.GitCommit=${finalAttrs.src.rev}"
    "-X grout/version.BuildType=Release"
  ];

  postInstall = ''
    mv $out/bin/app $out/bin/grout
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)"
      ];
    };

    # Firmware "pak" bundles for running grout on retro handhelds.
    paks =
      lib.mapAttrs
        (
          _: spec:
          callPackage ./pak.nix {
            grout = finalAttrs.finalPackage;
            inherit spec;
          }
        )
        (
          import ./paks.nix {
            inherit lib;
            inherit (finalAttrs) src;
          }
        );
  };

  meta = {
    description = "RomM client for Linux retro handhelds";
    homepage = "https://grout.romm.app/";
    license = lib.licenses.mit;
    mainProgram = "grout";
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
