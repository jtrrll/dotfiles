{
  constants,
  nixvim,
}: args: {
  imports = [
    ({
      args,
      lib,
      ...
    }: {
      assertions = [
        {
          assertion = lib.strings.hasInfix args.username args.homeDirectory;
          message = "homeDirectory (${args.homeDirectory}) must contain username (${args.username}).";
        }
      ];

      home = {
        inherit (args) homeDirectory username;
        stateVersion = "23.11";
      };

      imports = [
        nixvim
        ./modules
      ];

      programs.home-manager.enable = true;
    })
    {_module.args = {inherit args constants;};}
  ];
}
