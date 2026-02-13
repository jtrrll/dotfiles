{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules.ai = {
    environment =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        config.env = pkgs.buildEnv {
          name = "ai-environment";
          paths = config.packages;
        };

        options = {
          env = lib.mkOption {
            type = lib.types.package;
            description = "An environment for use by AI";
            readOnly = true;
          };
          packages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "The set of packages to appear in the AI environment";
          };
        };
      };
    harness =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        config.finalHarness =
          let
            binaryName = baseNameOf (lib.getExe config.harness);
            wrappedHarness =
              if (config ? env) then
                (pkgs.runCommand "${config.harness.name}-wrapped"
                  {
                    nativeBuildInputs = [ pkgs.makeWrapper ];
                  }
                  ''
                    mkdir -p $out/bin
                    makeWrapper ${lib.getExe config.harness} $out/bin/${binaryName} \
                      --set PATH ${config.env}/bin
                  ''
                ).overrideAttrs
                  { meta.mainProgram = binaryName; }
              else
                config.harness;
          in
          (pkgs.runCommand "ai-harness" { } ''
            mkdir -p $out/bin
            ln -s ${lib.getExe wrappedHarness} $out/bin/${binaryName}
            ln -s ${binaryName} $out/bin/ai
          '').overrideAttrs
            { meta.mainProgram = "ai"; };

        options = {
          harness = lib.mkOption {
            type = lib.types.package;
            description = "Base AI harness package";
          };
          finalHarness = lib.mkOption {
            type = lib.types.package;
            description = "Resulting AI harness package";
            readOnly = true;
          };
        };
      };
  };
}
