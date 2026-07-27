{
  config,
  inputs,
  ...
}:
let
  inherit (config) flake;
in
{
  config.flake.wrappers.fish = { config, lib, ... }: {
    imports = [ inputs.nix-wrapper-modules.wrapperModules.fish ];
    config = {
      drv.meta = config.package.meta // {
        inherit (flake.meta) homepage maintainers;
        description = "Personalized fish distribution";
        sourceProvenance = [ lib.sourceTypes.fromSource ];
      };
      configFile.content = ''
        function fish_greeting
        end

        function fish_prompt
          set --local last_status $status

          if set --query SSH_CLIENT
            set_color blue
            echo -n (whoami)'@'(hostname)' '
          end

          set_color magenta
          if test (pwd) = "$HOME"
            echo -n '~ '
          else
            echo -n (basename (pwd))' '
          end

          set --local branch (git branch --show-current 2>/dev/null)
          if test -n $branch
            set_color yellow
            echo -n $branch' '
          end

          if test $last_status -eq 0
            set_color green
          else
            set_color red
          end
          echo -n '> '

          set_color normal
          echo -ne '\e[5 q'
        end
      '';
    };
  };
}
