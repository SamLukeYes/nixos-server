# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  synced.caddy-secret-file = "${config.synced.configDir}/caddy/bandwagon.env";

  programs.rust-motd.settings = {
    last_login.root = 5;
    service_status.qemu-guest-agent = "qemu-guest-agent";
  };

  services.qemuGuest.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkfDt1Bv2cjUSRFgZpRC3WBD/zUoY7QWmjnaptYUHXm yes@absolute"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJhnrz/WzdK/jLp24kuVRY5J2RP94Jgzj+Ls0zw/kIxK Amaryllis"
    ];
  };
}

