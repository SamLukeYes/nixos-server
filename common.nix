{ config, lib, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  boot = {
    kernelParams = lib.optional (!config.zramSwap.enable) "zswap.enabled=1";
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  };

  time.timeZone = "Asia/Hong_Kong";
}