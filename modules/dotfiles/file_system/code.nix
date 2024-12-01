{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.dotfiles.file-system.enable {
    home.file.code = {
      target = "code/README.md";
      text = ''
        # ~/code

        A working directory for code. All repositories *should* be stored on an external Git server.

        ## Services (TODO)

        <!-- TODO: Implement services -->
        1. Daily Git fetch
        2. Daily top-level snekcheck

      '';
    };
  };
}
