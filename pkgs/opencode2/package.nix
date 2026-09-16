{
  autoPatchelfHook,
  cacert,
  coreutils,
  curl,
  fetchurl,
  git,
  gnused,
  jq,
  lib,
  nix,
  stdenv,
  stdenvNoCC,
  testers,
  versionCheckHook,
  writeShellApplication,
}:
let
  # Prebuilt, platform-specific bun binaries published to npm.
  sources = {
    aarch64-darwin = {
      name = "opencode-darwin-arm64";
      hash = "sha256-vI3tD1c1nKN6IH2phFaXUgPGP9PgKemLAeBzU5+2+Xc=";
    };
    aarch64-linux = {
      name = "opencode-linux-arm64";
      hash = "sha256-rAlgJlKDSZo8MeQGnSX10/DkEeW0u20W9jSmBr8lXHo=";
    };
    x86_64-linux = {
      name = "opencode-linux-x64";
      hash = "sha256-4fXraqo/TpSKA/OidLQo1xeai+w12pPTqqtBAAGUHzs=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode2";
  version = "0.0.0-beta-202608110357";

  src =
    let
      source =
        sources.${stdenvNoCC.hostPlatform.system}
          or (throw "opencode2: unsupported platform ${stdenvNoCC.hostPlatform.system}");
    in
    fetchurl {
      url = "https://registry.npmjs.org/${source.name}/-/${source.name}-${finalAttrs.version}.tgz";
      inherit (source) hash;
    };

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/opencode "$out/bin/${finalAttrs.meta.mainProgram}"
    runHook postInstall
  '';

  preVersionCheck = ''
    export HOME="$(mktemp -d)"
  '';
  versionCheckKeepEnvironment = [ "HOME" ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) ${finalAttrs.meta.mainProgram} --version";
    };

    updateScript = writeShellApplication {
      name = "update-opencode2";
      runtimeInputs = [
        cacert
        coreutils
        curl
        git
        gnused
        jq
        nix
      ];
      text = ''
        root=$(git rev-parse --show-toplevel)
        pkgFile="$root/pkgs/opencode2/package.nix"

        version=$(
          curl -fsSL https://registry.npmjs.org/opencode-ai \
            | jq -r '."dist-tags".beta'
        )
        if [ -z "$version" ] || [ "$version" = "null" ]; then
          echo "error: could not resolve the opencode-ai beta version" >&2
          exit 1
        fi
        echo "==> opencode2 beta version: $version"

        sed -i "s|version = \"[^\"]*\"|version = \"$version\"|" "$pkgFile"

        for name in \
          opencode-darwin-arm64 \
          opencode-linux-arm64 \
          opencode-linux-x64; do
          url="https://registry.npmjs.org/$name/-/$name-$version.tgz"
          hash=$(nix store prefetch-file --json "$url" | jq -r '.hash')
          echo "==> $name: $hash"
          # Replace the hash on the line following its `name = "..."` entry.
          sed -i "/name = \"$name\";/{n;s|hash = \"[^\"]*\"|hash = \"$hash\"|;}" "$pkgFile"
        done
      '';
    };
  };

  meta = {
    description = "AI coding agent built for the terminal (v2 beta)";
    homepage = "https://opencode.ai";
    mainProgram = "opencode2";
    platforms = lib.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
