{ config, lib, system, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  boot = {
    kernelParams = lib.optional (!config.zramSwap.enable) "zswap.enabled=1";
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  };

  documentation.nixos.enable = false;

  nixpkgs.hostPlatform = system;

  system = {
    stateVersion = "24.11";
    rebuild.enableNg = true;
    switch.enableNg = true;
  };

  time.timeZone = "Asia/Hong_Kong";
}