{ config, lib, pkgs, system, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = lib.optional (!config.zramSwap.enable) "zswap.enabled=1";
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  };

  documentation.nixos.enable = false;

  environment.defaultPackages = [];

  nixpkgs.hostPlatform = system;

  system = {
    stateVersion = "26.05";
    tools.nixos-option.enable = false;  # introduces cppnix dependency
  };

  time.timeZone = "Asia/Hong_Kong";
}