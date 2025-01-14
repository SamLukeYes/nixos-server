{ config, lib, ... }:

{
  options.synced.caddy-secret-file = lib.mkOption {
    type = lib.types.path;
    description = "Caddy env file of secrets.";
    example = "${config.synced.configDir}/caddy/secret.env";
  };

  config = {
    networking.firewall = rec {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = allowedTCPPorts;
    };

    programs.rust-motd.settings.service_status.caddy = "caddy";

    services.caddy = {
      enable = true;
      environmentFile = config.synced.caddy-secret-file;
      virtualHosts.myDomain.hostName = "{$DOMAIN_NAME}";
    };

    systemd.tmpfiles.rules = [
      "a ${config.synced.caddy-secret-file} - - - - u:${config.services.caddy.user}:r"
    ];
  };
}