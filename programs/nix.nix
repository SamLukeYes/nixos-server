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
      substituters = [
        "https://samlukeyes123.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "samlukeyes123.cachix.org-1:AsNJmUZGo73EYpBhz2w/XuysdNXxvf6WcZO7qWVh2TQ="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}