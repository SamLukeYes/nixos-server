{ pkgs, ... }:

# Only enable this for newly deployed machines
# Shouldn't be needed in case firewall and ports are properly set up

{
  programs.rust-motd.settings.fail2_ban.jails = [ "sshd" ];

  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
  };

  systemd.services.rust-motd.path = [ pkgs.fail2ban ];
}