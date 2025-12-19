#!/usr/bin/env nu

def main [] {
  gum style --bold --border=rounded --border-foreground=63 --foreground=212 --padding "1 2" "Configuration Activator"
  print "Usage: activate <home|os> [config]"
  exit 1
}

def "main home" [
  config?: string
] {
  gum style --bold --border=rounded --border-foreground=63 --foreground=212 --padding "1 2" "Home Configuration Activator"

  let selected_config = if ($config != null) {
    $config
  } else {
    "@HOME_CONFIGURATIONS@"
      | gum choose --header="Select a configuration to activate" --selected="default"
  }

  let styled_config = (gum style --bold --foreground=212 $selected_config)
  print $"Activating ($styled_config) home configuration..."

  with-env { NIXPKGS_ALLOW_UNFREE: "1" } {
    nh home switch --backup-extension bak --configuration $selected_config --impure --keep-going @ROOT_PATH@
  }

  print $"Activated ($styled_config) home configuration successfully!"
}

def "main os" [
  config?: string
] {
  gum style --bold --border=rounded --border-foreground=63 --foreground=212 --padding "1 2" "NixOS Configuration Activator"

  let selected_config = if ($config != null) {
    $config
  } else {
    "@NIXOS_CONFIGURATIONS@"
      | gum choose --header="Select a configuration to activate"
  }

  sudo --validate

  let styled_config = (gum style --bold --foreground=212 $selected_config)
  print $"Activating ($styled_config) NixOS configuration..."

  with-env {
    NIX_CONFIG: "extra-experimental-features = nix-command"
    NIXPKGS_ALLOW_UNFREE: "1"
  } {
    nh os switch --hostname $selected_config --impure @ROOT_PATH@
  }

  print $"Activated ($styled_config) NixOS configuration successfully!"
}
