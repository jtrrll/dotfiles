{
  inputs,
  self,
  ...
}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    checks = {
      nix-lint = pkgs.runCommandLocal "nix-lint" {} ''
        ${config.formatter}/bin/* --check ${self}/**
        touch $out
      '';
      snekcheck =
        pkgs.runCommandLocal "snekcheck" {
          buildInputs = [inputs.snekcheck.packages.${system}.snekcheck];
        } ''
          snekcheck ${self}/**
          touch $out
        '';
    };
  };
}
