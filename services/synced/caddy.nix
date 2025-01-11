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
      extraConfig = ''
        {$DOMAIN_NAME} {
            # https://blog.l3zc.com/2024/08/caddy-vless-proxy/
            @websockets {
                path {$WS_PATH}
                header Connection Upgrade
                header Upgrade websocket
            }
            handle @websockets {
                reverse_proxy [::1]:{$WS_PORT}
            }

            # Syncthing Web UI
            handle {
                basic_auth {
                    {$USER} {$HASHED_PASSWORD}
                }
                reverse_proxy http://localhost:8384 {
                    header_up Host {upstream_hostport}
                }
            }
        }
      '';
    };

    systemd.tmpfiles.rules = [
      "a ${config.synced.caddy-secret-file} - - - - u:${config.services.caddy.user}:r"
    ];
  };
  
}