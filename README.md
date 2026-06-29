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

- `default` - Activates a home or NixOS configuration

- `github-tf` - Manages GitHub repository with OpenTofu

- `update-demo` - Updates the demo gif

- `write-files` - Write all configured files to their paths

### `checks`

- `files/.github/CODEOWNERS`

- `files/.github/CODE_OF_CONDUCT.md`

- `files/.github/CONTRIBUTING.md`

- `files/.github/ISSUE_TEMPLATE/bug_report.yaml`

- `files/.github/ISSUE_TEMPLATE/config.yaml`

- `files/.github/ISSUE_TEMPLATE/documentation_issue.yaml`

- `files/.github/ISSUE_TEMPLATE/feature_request.yaml`

- `files/.github/PULL_REQUEST_TEMPLATE.md`

- `files/.github/dependabot.yaml`

- `files/.github/workflows/ci.yaml`

- `files/LICENSE`

- `files/README.md`

- `homeConfigurations/jtrrll/build`

- `metadata/packages`

- `nixosConfigurations/ares/build`

- `nixosConfigurations/athena/build`

- `packages/activate/build`

- `packages/bonsai/build`

- `packages/crt-shader/build`

- `packages/ds-shader/build`

- `packages/edit/build`

- `packages/gba-shader/build`

- `packages/gbc-shader/build`

- `packages/git-clone-with-worktrees/build`

- `packages/git-ezswitch/build`

- `packages/git-open/build`

- `packages/git-trim/build`

- `packages/keep-awake/build`

- `packages/matrix/build`

- `packages/neovim/build`

- `packages/neovim/nixvim-check`

- `packages/neovim/version`

- `packages/psp-shader/build`

- `packages/service-status/build`

- `packages/service-status/ports-endpoint`

- `packages/service-status/status-endpoint`

- `packages/service-status/version`

- `packages/splash/build`

- `snekcheck`

- `treefmt`

### `devShells`

- `default`

### `flakeModules`

- `default`

- `flakeMetadata`

- `packageMetadataChecks`

### `formatter`

### `homeConfigurations`

- `jtrrll` - Jackson Terrill's home configuration

### `homeModules`

- `bonsai`
  - `programs.bonsai.enable` - Whether to enable a bonsai tree screensaver. (default: `false`)

- `code-storage`
  - `services.codeStorage.enable` - Whether to enable self-maintaining directories for source code and worktrees. (default: `false`)
  - `services.codeStorage.frequency` - The interval at which code storage maintenance runs. (default: `"daily"`)

- `edit`
  - `programs.edit.enable` - Whether to enable edit. (default: `false`)
  - `programs.edit.package` - The edit package to use (default: `<derivation edit>`)

- `matrix`
  - `programs.matrix.enable` - Whether to enable a matrix rain screensaver. (default: `false`)

- `meta`
  - `meta.description` - A short description of this configuration. (default: `""`)

- `music-library`
  - `services.musicLibrary.enable` - Whether to enable a curated music library. (default: `false`)

- `service-status`
  - `services.serviceStatus.enable` - Whether to enable HTTP server that reports managed background service status. (default: `false`)
  - `services.serviceStatus.port` - Port to listen on. (default: `5679`)

- `snekcheck`
  - `programs.snekcheck.enable` - Whether to enable snekcheck. (default: `false`)
  - `programs.snekcheck.package` - The snekcheck package to use (default: `<derivation snekcheck-0.1.0>`)

### `nixosConfigurations`

- `ares` - jtrrll's gaming/workstation desktop

- `athena` - jtrrll's personal laptop

### `nixosModules`

- `meta`
  - `meta.description` - A short description of this configuration. (default: `""`)

- `romm`
  - `services.romm.dataDir` - Base directory for RomM persistent data (database, redis, resources, assets, config). (default: `"/var/lib/romm"`)
  - `services.romm.enable` - Whether to enable RomM, a self-hosted ROM manager and player. (default: `false`)
  - `services.romm.environmentFile` - Path to an environment file containing secrets. Must define at minimum:
  - `services.romm.image` - RomM container image derivation. (default: `<derivation docker-image-rommapp-romm-4.8.1.tar>`)
  - `services.romm.libraryDir` - Directory containing ROMs and BIOS files. (default: `"/var/lib/romm/library"`)
  - `services.romm.mariadbImage` - MariaDB container image derivation. (default: `<derivation docker-image-mariadb-11.4.tar>`)
  - `services.romm.openFirewall` - Whether to open the firewall for RomM's port. (default: `false`)
  - `services.romm.port` - Port to expose the RomM web UI on the host. (default: `8080`)
  - `services.romm.valkeyImage` - Valkey (Redis-compatible) container image derivation. (default: `<derivation docker-image-valkey-valkey-8.tar>`)

- `tests`
  - `tests` - Tests associated with this host. Each value is a derivation that succeeds if the test passes. (default: `{ }`)

- `users`
  - `dotfiles.users.enable` - Whether to enable user configurations. (default: `false`)

### `packages`

- `activate` - Activates a home or NixOS configuration

- `bonsai` - A botanical terminal screensaver

- `crt-shader` - A CRT shader that blends pixels

- `ds-shader` - A DS shader that replicates original hardware

- `edit` - Launches a text editor

- `gba-shader` - A GBA shader that replicates original hardware

- `gbc-shader` - A GB and GBC shader that replicates original hardware

- `git-clone-with-worktrees` - Clones a bare git repo and creates worktrees for each given suffix

- `git-ezswitch` - Interactively switches git branches

- `git-open` - Opens the upstream git repository in a browser

- `git-trim` - Deletes all working git branches and updates main branch

- `keep-awake` - Prevents system sleep while a command runs

- `matrix` - A cyberpunk terminal screensaver

- `neovim` - Personalized Neovim distribution built with Nixvim

- `psp-shader` - A PSP shader that replicates original hardware

- `service-status` - Serves managed background service status over HTTP

- `splash` - Prints a splash screen
