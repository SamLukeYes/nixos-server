{ pkgs, ... }:

{
  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
    package = pkgs.lix;

    settings = {
      builders-use-substitutes = true;
      experimental-features = [
        "flakes" "nix-command"
      ];
      flake-registry = "";
      narinfo-cache-negative-ttl = 300;
      substituters = [
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}