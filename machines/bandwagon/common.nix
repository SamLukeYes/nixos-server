# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ ... }:

{
  imports =
    [
      ../../services/endlessh.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.networkmanager.enable = true;

  programs.rust-motd.settings = {
    last_login.root = 5;
    service_status.qemu-guest-agent = "qemu-guest-agent";
  };

  services = {
    openssh.ports = [ 24107 ];
    qemuGuest.enable = true;
  };

  # Add to machine-specific config manually after copying swap file from old-root
  # swapDevices = [ 
  #   { device = "/swap"; }
  # ];

  users.users.root = {
    initialHashedPassword = "";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfaIo18sdaspu3ecLvBWgLheGAeMt3IEoyyeQ0PnE7Y root@absolute"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkfDt1Bv2cjUSRFgZpRC3WBD/zUoY7QWmjnaptYUHXm yes@absolute"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOJqjLdDHqsHN8uYZS69XhCYfCt3v+RCwSsBQKjbEfM Amaryllis"
    ];
  };
}

