# ~/.dotfiles

<!-- markdownlint-disable MD013 -->
![CI Status](https://img.shields.io/github/actions/workflow/status/jtrrll/dotfiles/ci.yaml?branch=main&label=ci&logo=github)
![License](https://img.shields.io/github/license/jtrrll/dotfiles?label=license&logo=googledocs&logoColor=white)
<!-- markdownlint-enable MD013 -->

My dotfiles collection for configuring frequently used programs.
Managed via [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager)

![Demo](./demo.gif)

## Usage

1. [Install Nix](https://zero-to-nix.com/start/install)
2. Activate a configuration interactively by running the following:

    ```sh
    nix run github:jtrrll/dotfiles home
    ```

## Outputs

### `apps`

<details>
<summary>Show 5</summary>

- `default` - Activates a home or NixOS configuration

- `github-tf` - Manages GitHub repository with OpenTofu

- `update-demo` - Updates the demo gif

- `update-packages` - Runs each package's own updateScript

- `write-files` - Write all configured files to their paths

</details>

### `checks`

<details>
<summary>Show 63</summary>

- `files:.github/CODEOWNERS`

- `files:.github/CODE_OF_CONDUCT.md`

- `files:.github/CONTRIBUTING.md`

- `files:.github/ISSUE_TEMPLATE/bug_report.yaml`

- `files:.github/ISSUE_TEMPLATE/config.yaml`

- `files:.github/ISSUE_TEMPLATE/documentation_issue.yaml`

- `files:.github/ISSUE_TEMPLATE/feature_request.yaml`

- `files:.github/PULL_REQUEST_TEMPLATE.md`

- `files:.github/dependabot.yaml`

- `files:.github/workflows/ci.yaml`

- `files:.github/workflows/update-packages.yaml`

- `files:LICENSE`

- `files:README.md`

- `homeConfigurations:jtrrll/build`

- `lib`

- `nixosConfigurations:ares/build`

- `nixosConfigurations:ares/tests/romm/http`

- `nixosConfigurations:ares/tests/romm/postgresql`

- `nixosConfigurations:athena/build`

- `packages:activate/build`

- `packages:activate/metadata`

- `packages:bonsai/build`

- `packages:bonsai/metadata`

- `packages:edit/build`

- `packages:edit/metadata`

- `packages:git-clone-with-worktrees/build`

- `packages:git-clone-with-worktrees/metadata`

- `packages:git-ezswitch/build`

- `packages:git-ezswitch/metadata`

- `packages:git-open/build`

- `packages:git-open/metadata`

- `packages:git-trim/build`

- `packages:git-trim/metadata`

- `packages:grout/build`

- `packages:grout/metadata`

- `packages:keep-awake/build`

- `packages:keep-awake/metadata`

- `packages:matrix/build`

- `packages:matrix/metadata`

- `packages:neovim/build`

- `packages:neovim/metadata`

- `packages:neovim/tests/nixvim-check`

- `packages:neovim/tests/version`

- `packages:rahasher/build`

- `packages:rahasher/metadata`

- `packages:romm/build`

- `packages:romm/metadata`

- `packages:service-status/build`

- `packages:service-status/metadata`

- `packages:service-status/tests/journal-endpoint`

- `packages:service-status/tests/ports-endpoint`

- `packages:service-status/tests/status-endpoint`

- `packages:service-status/tests/version`

- `packages:session/build`

- `packages:session/metadata`

- `packages:shader-pack/build`

- `packages:shader-pack/metadata`

- `packages:splash/build`

- `packages:splash/metadata`

- `packages:zellij-agent-handler/build`

- `packages:zellij-agent-handler/metadata`

- `packages:zellij-agent-handler/tests/is-valid-wasm`

- `treefmt`

</details>

### `devShells`

<details>
<summary>Show 1</summary>

- `default`

</details>

### `flakeModules`

<details>
<summary>Show 9</summary>

- `default`

- `flake-metadata`

- `home-configuration-build-checks`

- `nixos-configuration-build-checks`

- `nixos-configuration-test-checks`

- `package-build-checks`

- `package-metadata-checks`

- `package-passthru-tests-checks`

- `packages-by-name`

</details>

### `formatter`

### `homeConfigurations`

<details>
<summary>Show 1</summary>

- `jtrrll` - Jackson Terrill's home configuration

</details>

### `homeModules`

<details>
<summary>Show 9</summary>

- `bonsai`
  - `programs.bonsai.enable` - Whether to enable a bonsai tree screensaver. (default: `false`)

- `code-storage`
  - `services.codeStorage.directory` - Directory in which bare git repositories are stored. (default: `"${config.home.homeDirectory}/code"`)
  - `services.codeStorage.enable` - Whether to enable self-maintaining directories for source code and worktrees. (default: `false`)
  - `services.codeStorage.frequency` - The interval at which code storage maintenance runs. (default: `"daily"`)

- `edit`
  - `programs.edit.enable` - Whether to enable edit. (default: `false`)
  - `programs.edit.package` - The edit package to use (default: `<derivation edit>`)

- `matrix`
  - `programs.matrix.enable` - Whether to enable a matrix rain screensaver. (default: `false`)

- `meta`
  - `meta.description` - A short description of this configuration. (default: `""`)
  - `meta.tags` - Strings used to categorize this configuration. (default: `[ ]`)

- `music-library`
  - `services.musicLibrary.enable` - Whether to enable a curated music library. (default: `false`)

- `service-status`
  - `services.serviceStatus.enable` - Whether to enable HTTP server that reports managed background service status. (default: `false`)
  - `services.serviceStatus.port` - Port to listen on. (default: `5679`)

- `sessions`
  - `programs.sessions.codeDirectory` - Directory containing the bare git repositories that sessions check (default: `"${config.home.homeDirectory}/code"`)
  - `programs.sessions.directory` - Directory under which sessions and their worktrees live. (default: `"${config.home.homeDirectory}/sessions"`)
  - `programs.sessions.enable` - Whether to enable development sessions bundling git worktrees and a zellij session. (default: `false`)
  - `programs.sessions.package` - The `session` CLI package to install. (default: `pkgs.session`)

- `snekcheck`
  - `programs.snekcheck.enable` - Whether to enable snekcheck. (default: `false`)
  - `programs.snekcheck.package` - The snekcheck package to use (default: `<derivation snekcheck-0.1.0>`)

</details>

### `nixosConfigurations`

<details>
<summary>Show 2</summary>

- `ares` - jtrrll's gaming/workstation desktop

- `athena` - jtrrll's personal laptop

</details>

### `nixosModules`

<details>
<summary>Show 4</summary>

- `meta`
  - `meta.description` - A short description of this configuration. (default: `""`)
  - `meta.tags` - Strings used to categorize this configuration. (default: `[ ]`)

- `romm`
  - `services.romm.baseUrl` - Public URL of this RomM instance (ROMM_BASE_URL). (default: `"http://0.0.0.0"`)
  - `services.romm.dataDir` - Base directory for RomM persistent data (resources, assets, config, redis). (default: `"/var/lib/romm"`)
  - `services.romm.database.driver` - Database driver RomM connects with (ROMM_DB_DRIVER). (default: `"mariadb"`)
  - `services.romm.database.host` - Host name of the database RomM connects to (DB_HOST).
  - `services.romm.database.name` - Database name RomM connects to (DB_NAME). (default: `"romm"`)
  - `services.romm.database.port` - Port of the database RomM connects to (DB_PORT). (default: `if driver == "postgresql" then 5432 else 3306`)
  - `services.romm.database.user` - Database user RomM connects as (DB_USER). (default: `"romm"`)
  - `services.romm.enable` - Whether to enable RomM, a self-hosted ROM manager and player. (default: `false`)
  - `services.romm.environmentFiles` - Environment files for the RomM service. Must define (default: `[ ]`)
  - `services.romm.gunicornSocket` - Path of the Unix socket the backend's gunicorn server listens on. (default: `"/run/romm/gunicorn.sock"`)
  - `services.romm.libraryDir` - Directory containing ROMs and BIOS files. (default: `"/var/lib/romm/library"`)
  - `services.romm.logLevel` - Application log level (LOGLEVEL). (default: `"INFO"`)
  - `services.romm.metadataProviders.flashpoint.enable` - Whether to enable the Flashpoint metadata provider (FLASHPOINT_API_ENABLED). (default: `false`)
  - `services.romm.metadataProviders.hasheous.enable` - Whether to enable the Hasheous metadata provider (HASHEOUS_API_ENABLED). (default: `false`)
  - `services.romm.metadataProviders.hltb.enable` - Whether to enable the HowLongToBeat metadata provider (HLTB_API_ENABLED). (default: `false`)
  - `services.romm.metadataProviders.launchbox.enable` - Whether to enable the LaunchBox metadata provider (LAUNCHBOX_API_ENABLED). (default: `false`)
  - `services.romm.metadataProviders.playmatch.enable` - Whether to enable the PlayMatch metadata provider (PLAYMATCH_API_ENABLED). (default: `false`)
  - `services.romm.metadataProviders.retroachievements.cacheRefreshDays` - RetroAchievements metadata cache refresh interval in days (default: `30`)
  - `services.romm.metadataProviders.tgdb.enable` - Whether to enable the TheGamesDB metadata provider (TGDB_API_ENABLED). (default: `false`)
  - `services.romm.nginx.enable` - Whether to configure `services.nginx` to serve the RomM frontend and (default: `true`)
  - `services.romm.openFirewall` - Whether to open the firewall for RomM's port. (default: `false`)
  - `services.romm.package` - The RomM package to run. (default: `pkgs.romm`)
  - `services.romm.port` - Host port to expose the RomM web UI on. (default: `8080`)
  - `services.romm.rahasher` - RAHasher package providing the `RAHasher` binary used to compute (default: `pkgs.rahasher`)
  - `services.romm.settings` - Environment variables for the RomM application, merged (default: `{ }`)

- `tests`
  - `tests` - Tests associated with this host. Each value is a derivation that succeeds if the test passes. (default: `{ }`)

- `users`
  - `dotfiles.users.enable` - Whether to enable user configurations. (default: `false`)

</details>

### `overlays`

<details>
<summary>Show 1</summary>

- `default`

</details>

### `packages`

<details>
<summary>Show 18</summary>

- `activate` - Activates a home or NixOS configuration

- `bonsai` - A botanical terminal screensaver

- `edit` - Launches a text editor

- `git-clone-with-worktrees` - Clones a bare git repo and creates worktrees for each given suffix

- `git-ezswitch` - Interactively switches git branches

- `git-open` - Opens the upstream git repository in a browser

- `git-trim` - Deletes all working git branches and updates main branch

- `grout` - RomM client for Linux retro handhelds

- `keep-awake` - Prevents system sleep while a command runs

- `matrix` - A cyberpunk terminal screensaver

- `neovim` - Personalized Neovim distribution built with Nixvim

- `rahasher` - Hashing tool from RALibretro used by RomM for RetroAchievements

- `romm` - Self-hosted ROM manager and player

- `service-status` - Serves managed background service status over HTTP

- `session` - Manage development sessions as git worktrees and a zellij session

- `shader-pack` - A collection of RetroArch slang shaders for various platforms

- `splash` - Prints a splash screen

- `zellij-agent-handler` - Zellij plugin: agent status bar with click-to-navigate

</details>
