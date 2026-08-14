{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python313,
  stdenvNoCC,
}:
let
  python = python313.override {
    self = python;
    packageOverrides = final: prev: {
      crontab = final.callPackage ./crontab.nix { };
      strsimpy = final.callPackage ./strsimpy.nix { };
      zipfile-inflate64 = final.callPackage ./zipfile_inflate64.nix { };
      rq-scheduler = final.callPackage ./rq_scheduler.nix { };

      fastapi = prev.fastapi.overridePythonAttrs (_old: rec {
        version = "0.134.0";
        src = fetchPypi {
          pname = "fastapi";
          inherit version;
          hash = "sha256-MSKx6g2+qrSLWXboC5nKftoCvhVL8D4SajMiDnMlWpo=";
        };
      });

      starlette = prev.starlette.overridePythonAttrs (_old: rec {
        version = "1.0.1";
        src = fetchPypi {
          pname = "starlette";
          inherit version;
          hash = "sha256-USOZxfHef6yZyIVyIS3tnd7d7y+zKvqC1yQADoizj08=";
        };
      });

      fastapi-pagination = prev.fastapi-pagination.overridePythonAttrs (_old: rec {
        version = "0.15.0";
        src = fetchPypi {
          pname = "fastapi_pagination";
          inherit version;
          hash = "sha256-Ef45y+GB7TwYkZuQ+va/y+QMtZaqnFKpi7zoURGimk8=";
        };
      });
    };
  };

  pythonEnv = python.withPackages (ps: [
    ps.aiohttp
    ps.alembic
    ps.anyio
    ps.asyncssh
    ps.authlib
    ps.colorama
    ps.cryptography
    ps.defusedxml
    ps.email-validator
    ps.fastapi
    ps.fastapi-pagination
    ps.gunicorn
    ps.httptools
    ps.httpx
    ps.itsdangerous
    ps.jinja2
    ps.joserfc
    ps.mutagen
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
    ps.pydantic-extra-types
    ps.pydantic-settings
    ps.pydash
    ps.python-dotenv
    ps.python-magic
    ps.python-multipart
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
    ps.ua-parser
    ps.unidecode
    ps.uvicorn
    ps.uvicorn-worker
    ps.uvloop
    ps.watchfiles
    ps.websockets
    ps.yarl
    ps.zipfile-inflate64
    ps.zstandard
    # runtime helpers used by the socket/worker layers
    ps.bcrypt
    ps.mysqlclient
  ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "romm-backend";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = finalAttrs.version;
    hash = "sha256-1LUWXt89lXId32RFDVV4wOkrPwPtnFVVKEnycAS/Nrg=";
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
