{
  runNixOSTest,
  writeText,
}:
runNixOSTest {
  name = "romm";

  nodes.server = {
    virtualisation = {
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
    server.wait_for_unit("podman-romm-db.service", timeout=60)
    server.wait_for_unit("podman-romm-redis.service", timeout=60)
    server.wait_for_unit("podman-romm.service", timeout=60)
    server.wait_for_open_port(8080, timeout=60)
    server.succeed("curl -sf http://localhost:8080")
  '';
}
