{
  bun,
  cacert,
  coreutils,
  curl,
  fetchFromGitHub,
  git,
  gnused,
  installShellFiles,
  jq,
  lib,
  makeBinaryWrapper,
  models-dev,
  nix,
  nodejs,
  ripgrep,
  stdenvNoCC,
  sysctl,
  versionCheckHook,
  wayland,
  writableTmpDirAsHomeHook,
  writeShellApplication,
}:
let
  nodeModulesHashes = {
    aarch64-darwin = "sha256-wAea8+jajnMDxZ6XJL+Hsrf0621hwtBtWyD1+dS45dE=";
    aarch64-linux = "sha256-Wc8OT2DRZpVo56KaoGE0Hsj1NDknakbWXO9w2qy6j+0=";
    x86_64-linux = "sha256-U9IuP/ev6w4urvogOwQyl3rdumY6W4YaY18NkFaOVHU=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode2";
  version = "2.0.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SdZ+VFhhld8R0yYgHtfIgq8kL46xAnAJ4QrRfbKiOw=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "opencode2-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [ bun ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="${if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x64"}" \
        --os="${if stdenvNoCC.hostPlatform.isLinux then "linux" else "darwin"}" \
        --filter '!./' \
        --filter './packages/cli' \
        --filter './packages/desktop' \
        --filter './packages/app' \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      bun --bun ./nix/scripts/canonicalize-node-modules.ts
      bun --bun ./nix/scripts/normalize-bun-binaries.ts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;
      runHook postInstall
    '';

    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash =
      nodeModulesHashes.${stdenvNoCC.hostPlatform.system}
        or (throw "opencode2: unsupported platform ${stdenvNoCC.hostPlatform.system}");
  };

  nativeBuildInputs = [
    bun
    nodejs
    installShellFiles
    makeBinaryWrapper
    models-dev
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    substituteInPlace packages/script/src/index.ts \
      --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                     'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env = {
    MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    OPENCODE_DISABLE_MODELS_FETCH = true;
    OPENCODE_VERSION = finalAttrs.version;
    OPENCODE_CHANNEL = "prod";
    NODE_OPTIONS = "--max-old-space-size=4096";
  };

  buildPhase = ''
    runHook preBuild

    cd ./packages/cli
    bun --bun ./script/build.ts --single --skip-install

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli-*/bin/opencode "$out/bin/${finalAttrs.meta.mainProgram}"

    # OpenTUI dlopens Wayland for clipboard images.
    wrapProgram "$out/bin/${finalAttrs.meta.mainProgram}" ${
      lib.escapeShellArgs (
        [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath ([ ripgrep ] ++ lib.optional stdenvNoCC.hostPlatform.isDarwin sysctl))
        ]
        ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
          "--prefix"
          "LD_LIBRARY_PATH"
          ":"
          (lib.makeLibraryPath [ wayland ])
        ]
        ++ [
          "--set"
          "OPENCODE_DISABLE_AUTOUPDATE"
          "true"
        ]
      )
    }

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/${finalAttrs.meta.mainProgram} completion)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "OPENCODE_DISABLE_MODELS_FETCH"
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = writeShellApplication {
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
      repo="anomalyco/opencode"

      version=$(
        curl -fsSL "https://api.github.com/repos/$repo/tags?per_page=100" \
          | jq -r '.[].name | select(startswith("v2."))' \
          | sed 's/^v//' \
          | sort -V \
          | tail -n1
      )
      if [ -z "$version" ]; then
        echo "error: could not resolve the latest opencode v2 tag" >&2
        exit 1
      fi
      echo "==> opencode2 version: $version"
      sed -i "s|version = \"[^\"]*\"|version = \"$version\"|" "$pkgFile"

      srcHash=$(
        nix store prefetch-file --json --unpack \
          "https://github.com/$repo/archive/refs/tags/v$version.tar.gz" \
          | jq -r '.hash'
      )
      echo "==> src: $srcHash"
      sed -i "s|hash = \"sha256-[^\"]*\"|hash = \"$srcHash\"|" "$pkgFile"

      hashes=$(curl -fsSL "https://raw.githubusercontent.com/$repo/v$version/nix/hashes.json")
      for system in aarch64-darwin aarch64-linux x86_64-linux; do
        hash=$(echo "$hashes" | jq -r ".nodeModules.\"$system\"")
        echo "==> node_modules $system: $hash"
        sed -i "/$system = \"sha256-/s|sha256-[^\"]*|''${hash#sha256-}|" "$pkgFile"
      done
    '';
  };

  meta = {
    description = "AI coding agent built for the terminal (v2)";
    homepage = "https://opencode.ai";
    mainProgram = "opencode";
    platforms = lib.attrNames nodeModulesHashes;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
