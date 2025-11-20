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

  with-env { NIXPKGS_ALLOW_UNFREE: "1" } {
    gum spin --show-error --spinner line --title $"Activating ($styled_config) home configuration..." -- home-manager switch -b bak --flake $"@ROOT_PATH@#($selected_config)" --impure
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

  let styled_config = (gum style --bold --foreground=212 $selected_config)

  sudo --validate

  with-env { NIXPKGS_ALLOW_UNFREE: "1" } {
    gum spin --show-error --spinner line --title $"Activating ($styled_config) NixOS configuration..." -- sudo --preserve-env="NIXPKGS_ALLOW_UNFREE" nixos-rebuild switch --flake $"@ROOT_PATH@#($selected_config)" --impure
  }

  print $"Activated ($styled_config) NixOS configuration successfully!"
}
