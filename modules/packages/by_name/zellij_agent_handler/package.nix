{
  lib,
  pkgsCross,
  runCommand,
  zellijPlugins,
}:
let
  wasi = pkgsCross.wasi32;
  cargoToml = builtins.fromTOML (builtins.readFile ./cargo.toml);
in
(zellijPlugins.wrapper "zellij-agent-handler" (
  wasi.rustPlatform.buildRustPackage {
    pname = cargoToml.package.name;
    inherit (cargoToml.package) version;
    meta = {
      description = "Zellij plugin: agent status bar with click-to-navigate";
      platforms = lib.platforms.all;
    };

    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./cargo.toml
        ./cargo.lock
        ./src
      ];
    };
    cargoLock.lockFile = ./cargo.lock;
    nativeBuildInputs = [ wasi.lld ];
    env.RUSTFLAGS = "-C linker=wasm-ld";
  }
)).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      passthru = previousAttrs.passthru or { } // {
        integrations.opencode-plugin = ./integrations/opencode_plugin.ts;
        tests.is-valid-wasm =
          runCommand "zellij-agent-handler-wasm-check"
            {
              meta.description = "Verifies the output starts with the WASM magic bytes (\\0asm)";
            }
            ''
              header=$(od -A n -t x1 -N 4 ${finalAttrs.finalPackage})
              expected="00 61 73 6d"
              if [ "$header" != " $expected" ]; then
                echo "Not a valid WASM file. Got header: $header"
                exit 1
              fi
              touch $out
            '';
      };
    }
  )
