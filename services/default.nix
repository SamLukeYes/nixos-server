{
  imports = [
    ./synced
    ./fail2ban.nix
    ./openssh.nix
  ];

  # https://github.com/NixOS/nixpkgs/issues/84105
  # start tty0 on serial console
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];  # to start at boot
    serviceConfig.Restart = "always";  # restart when session is closed
  };
}