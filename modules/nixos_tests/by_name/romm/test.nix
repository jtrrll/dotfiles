{
  runNixOSTest,
  writeText,
}:
runNixOSTest {
  name = "romm";
  globalTimeout = 60 * 3;

  nodes.server = {
    virtualisation = {
      diskSize = 1024 * 4;
      podman.enable = true;
      oci-containers.backend = "podman";
    };

    services.romm = {
      enable = true;
      environmentFile = writeText "romm-env" ''
        DB_PASSWD=testpassword
        MARIADB_PASSWORD=testpassword
        MARIADB_ROOT_PASSWORD=rootpassword
        ROMM_AUTH_SECRET_KEY=0000000000000000000000000000000000000000000000000000000000000000
      '';
    };
  };

  testScript = ''
    server.wait_for_unit("podman-romm-db.service", timeout=90)
    server.wait_for_unit("podman-romm-redis.service", timeout=90)
    server.wait_for_unit("podman-romm.service", timeout=90)
    server.wait_for_open_port(8080, timeout=90)
    server.succeed("curl -sf http://localhost:8080")
  '';
}
