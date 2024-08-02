{pkgs, ...}: {
  home.packages = [
    (pkgs.writers.writePython3Bin "home" {
        libraries = [pkgs.python312Packages.cyclopts];
      } ''
        import cyclopts
        from rich import box, console, panel, text
        import subprocess
        import sys

        app = cyclopts.App()
        console = console.Console()


        def format_message(msg: str, title: str | None = None,
                           style: str | None = None) -> panel.Panel:
            return panel.Panel(
                text.Text(msg, "default"),
                title=title,
                style=style,
                box=box.ROUNDED,
                expand=True,
                title_align="left"
            )


        def print_error(msg: str) -> None:
            console.print(format_message(msg=msg, title="Error", style="red"))


        @app.command
        def activate_latest(config: str = ""):
            """Activate the latest version of a home configuration.

            Parameters
            ----------
            config
                The home configuration to activate.
            """

            if config:
                config = f"#{config}"

            try:
                command = [
                    "home-manager",
                    "switch",
                    "-b",
                    "backup",
                    "--impure",
                    "--flake",
                    f"github:jtrrll/dotfiles{config}"
                ]

                with console.status("Activating configuration..."):
                    subprocess.run(command, capture_output=True, check=True, text=True)
                console.print(format_message(
                    msg="Configuration activated!", title="Success", style="green"
                ))
            except KeyboardInterrupt:
                print_error(msg="Activation interrupted by user")
                sys.exit(1)
            except Exception:
                print_error(msg="Failed to activate configuration")
                sys.exit(1)


        if __name__ == "__main__":
            app()
      '')
  ];
}
