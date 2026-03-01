{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config.flake.modules.ai.harness =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        env = pkgs.buildEnv {
          name = "ai-environment";
          paths = config.packages;
        };
        finalHarness =
          let
            binaryName = baseNameOf (lib.getExe config.harness);
            wrappedHarness =
              (pkgs.runCommand "${config.harness.name}-wrapped"
                {
                  nativeBuildInputs = [ pkgs.makeWrapper ];
                }
                ''
                  mkdir -p $out/bin
                  makeWrapper ${lib.getExe config.harness} $out/bin/${binaryName} \
                    --prefix PATH : ${config.env}/bin
                ''
              ).overrideAttrs
                { meta.mainProgram = binaryName; };
          in
          (pkgs.runCommand "ai-harness" { } ''
            mkdir -p $out/bin
            ln -s ${lib.getExe wrappedHarness} $out/bin/${binaryName}
            ln -s ${binaryName} $out/bin/ai
          '').overrideAttrs
            { meta.mainProgram = "ai"; };
      };

      options = {
        env = lib.mkOption {
          type = lib.types.package;
          description = "An environment for use by AI";
          readOnly = true;
        };
        harness = lib.mkOption {
          type = lib.types.package;
          default = pkgs.opencode;
          description = "Base AI harness package";
        };
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "The set of packages to appear in the AI environment";
        };

        finalHarness = lib.mkOption {
          type = lib.types.package;
          description = "Resulting AI harness package";
          readOnly = true;
        };
      };
    };
}
