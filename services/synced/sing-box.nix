{ config, lib, ... }:

{
  options.synced.sing-box-inbounds = lib.mkOption {
    default = "${config.synced.configDir}/sing-box-inbounds.json";
    type = lib.types.path;
  };

  config ={
    programs.rust-motd.settings.service_status.sing-box = "sing-box";

    services = {
      sing-box = {
        enable = true;
        settings = {
          inbounds = {
            _secret = config.synced.sing-box-inbounds;
            quote = false;
          };
        };
      };

      caddy.virtualHosts.myDomain.extraConfig = ''
        # https://blog.l3zc.com/2024/08/caddy-vless-proxy/
        @websockets {
            path {$WS_PATH}
            header Connection Upgrade
            header Upgrade websocket
        }
        handle @websockets {
            reverse_proxy [::1]:{$WS_PORT}
        }
      '';
    };
  };
}