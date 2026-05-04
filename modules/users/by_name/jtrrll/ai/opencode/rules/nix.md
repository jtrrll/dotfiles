## Nix Rules

Always pass `--print-build-logs` when running `nix build`, `nix develop`, `nix run`, or similar commands.
This prints full build logs to stdout so failures can be diagnosed without re-running.

Wrap long-running nix commands with `keep-awake` to prevent the system from sleeping during builds.
For example: `keep-awake nix build --print-build-logs`.
