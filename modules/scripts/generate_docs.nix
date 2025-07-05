{self, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    scripts.generate-docs = pkgs.writeShellApplication {
      meta.description = "Inserts options documentation for the dotfiles module into the README.";
      name = "generate-docs";
      runtimeInputs = [
        pkgs.gawk
        pkgs.uutils-coreutils-noprefix
      ];
      text = ''
        awk '/<!-- BEGIN OPTIONS -->/{flag=1;print;system("cat ${self.packages.${system}.options}");next}/<!-- END OPTIONS -->/{flag=0} !flag' README.md > README.tmp
        mv README.tmp README.md
      '';
    };
  };
}
