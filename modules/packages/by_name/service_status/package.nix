{
  lib,
  buildGoModule,
  curl,
  testers,
  versionCheckHook,
  writeShellApplication,
}:
buildGoModule (finalAttrs: {
  pname = "service-status";
  version = "0.1.0";
  src = ./src;
  vendorHash = "sha256-n9x5Tkw0lR5N/k9AWt662l1ZnrQZV1UB6OF7vV1C3ZE=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    status-endpoint = writeShellApplication {
      name = "${finalAttrs.pname}-status-test";
      runtimeInputs = [
        curl
        finalAttrs.finalPackage
      ];
      text = ''
        service-status --port 19876 &
        pid=$!
        trap 'kill $pid 2>/dev/null' EXIT
        sleep 1

        response=$(curl -sf http://127.0.0.1:19876/status)
        if ! echo "$response" | grep -q '"state"'; then
          echo "unexpected /status response: $response"
          exit 1
        fi
      '';
    };
    ports-endpoint = writeShellApplication {
      name = "${finalAttrs.pname}-ports-test";
      runtimeInputs = [
        curl
        finalAttrs.finalPackage
      ];
      text = ''
        service-status --port 19877 &
        pid=$!
        trap 'kill $pid 2>/dev/null' EXIT
        sleep 1

        response=$(curl -sf http://127.0.0.1:19877/ports)
        if ! echo "$response" | grep -q '"port"'; then
          echo "unexpected /ports response: $response"
          exit 1
        fi

        # The service itself should appear in the ports list
        if ! echo "$response" | grep -q 'service-status'; then
          echo "service-status not found in /ports response: $response"
          exit 1
        fi
      '';
    };
  };

  meta = {
    description = "Serves managed background service status over HTTP";
    mainProgram = "service-status";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
