{
  nix.settings = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
  };
}
