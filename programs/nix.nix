{ pkgs, ... }:

{
  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
    package = pkgs.nix;

    settings = {
      builders-use-substitutes = true;
      experimental-features = [
        "flakes" "nix-command"
      ];
      flake-registry = "";
      narinfo-cache-negative-ttl = 300;
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://samlukeyes123.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "samlukeyes123.cachix.org-1:AsNJmUZGo73EYpBhz2w/XuysdNXxvf6WcZO7qWVh2TQ="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}