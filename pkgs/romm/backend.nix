{
  lib,
  fetchFromGitHub,
  python313,
  stdenvNoCC,
}:
let
  python = python313.override {
    self = python;
    packageOverrides = final: _prev: {
      crontab = final.callPackage ./crontab.nix { };
      strsimpy = final.callPackage ./strsimpy.nix { };
      zipfile-inflate64 = final.callPackage ./zipfile_inflate64.nix { };
      rq-scheduler = final.callPackage ./rq_scheduler.nix { };
    };
  };

  pythonEnv = python.withPackages (ps: [
    ps.aiohttp
    ps.alembic
    ps.anyio
    ps.authlib
    ps.colorama
    ps.defusedxml
    ps.fastapi
    ps.fastapi-pagination
    ps.gunicorn
    ps.httpx
    ps.itsdangerous
    ps.joserfc
    ps.opentelemetry-distro
    ps.opentelemetry-exporter-otlp
    ps.opentelemetry-instrumentation-aiohttp-client
    ps.opentelemetry-instrumentation-fastapi
    ps.opentelemetry-instrumentation-httpx
    ps.opentelemetry-instrumentation-redis
    ps.opentelemetry-instrumentation-sqlalchemy
    ps.passlib
    ps.pillow
    ps.psycopg
    ps.psycopg-c
    ps.pydantic
    ps.pydash
    ps.python-dotenv
    ps.python-magic
    ps.python-socketio
    ps.pyyaml
    ps.redis
    ps.rq
    ps.rq-scheduler
    ps.sentry-sdk
    ps.sqlalchemy
    ps.starlette
    ps.streaming-form-data
    ps.strsimpy
    ps.unidecode
    ps.uvicorn
    ps.uvicorn-worker
    ps.watchfiles
    ps.yarl
    ps.zipfile-inflate64
    # runtime helpers used by the socket/worker layers
    ps.bcrypt
    ps.mysqlclient
  ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "romm-backend";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = finalAttrs.version;
    hash = "sha256-/HOY/N5ykqRBw5IPlO4gJGyrZhPeKMXeDT2/pBSrUhs=";
  };

  # The backend is run directly from its source tree (uv run python main.py),
  # not installed as a wheel. Ship the source plus a Python environment with all
  # runtime dependencies.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/romm
    cp -r backend $out/share/romm/backend
    cp -r alembic.ini $out/share/romm/ 2>/dev/null || true
    ln -s ${pythonEnv} $out/share/romm/python-env
    runHook postInstall
  '';

  passthru = { inherit pythonEnv; };

  meta = {
    description = "Backend application for RomM";
    homepage = "https://romm.app";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
