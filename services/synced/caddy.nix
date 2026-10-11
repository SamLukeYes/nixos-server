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
      virtualHosts.myDomain = {
        hostName = "{$DOMAIN_NAME}";
        logFormat = ''
          output file ${config.services.caddy.logDir}/access.log
        '';
      };
    };

    systemd = {
      services.sing-box.serviceConfig = {
        RestartSteps = 5;
        RestartMaxDelaySec = "15min";
      };

      # run `systemd-tmpfiles --create && systemctl restart caddy` after creating new secret file
      tmpfiles.rules = [
        "a ${config.synced.caddy-secret-file} - - - - u:${config.services.caddy.user}:r"
      ];
    };
  };
}