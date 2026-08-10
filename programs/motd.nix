{ lib, pkgs, ... }:

{
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "white";
        command = "${lib.getExe pkgs.fastfetch} --logo-type none --detect-version false";
      };
    };
  };

  # let fastfetch see mount points other than /
  systemd.services.rust-motd.serviceConfig.PrivateDevices = lib.mkForce false;
}