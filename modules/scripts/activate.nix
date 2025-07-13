{
  configurations ? [],
  gum,
  home-manager,
  self,
  uutils-coreutils-noprefix,
  writeShellApplication,
}:
writeShellApplication {
  meta.description = "Activates a home configuration.";
  name = "activate";
  runtimeInputs = [
    gum
    home-manager
    uutils-coreutils-noprefix
  ];
  text = ''
    gum style \
      --bold \
      --border=rounded \
      --border-foreground=63 \
      --foreground=212 \
      --padding "1 2" \
      "Home Configuration Activator"

    if [[ "$#" -eq 1 ]]; then
      config="$1"
    elif [[ "$#" -eq 0 ]]; then
      config=$(printf "${assert builtins.isList configurations && builtins.all builtins.isString configurations; builtins.concatStringsSep "\n" configurations}" | gum choose --header="Select a configuration to activate" --selected="default")
    else
      gum style \
        --foreground=1 \
        "Usage: $(basename "$0") <config>"
      exit 1
    fi

    styled_config=$(gum style --bold --foreground=212 "$config")

    gum spin \
      --show-error \
      --spinner line \
      --title "Activating $styled_config configuration..." \
      -- home-manager switch -b bak --flake "${self}#$config" --impure

    printf "Activated %s configuration successfully!\n" "$styled_config"
  '';
}
