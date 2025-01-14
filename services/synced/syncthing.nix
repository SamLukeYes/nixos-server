{ config, lib, ... }:

{
  options.synced.configDir = lib.mkOption {
    default = "${config.services.syncthing.dataDir}/Sync";
    type = lib.types.path;
    description = "Directory of config files managed by Syncthing.";
  };

  config = {
    programs.rust-motd.settings.service_status.syncthing = "syncthing";

    services = {
      syncthing = {
        enable = true;
        openDefaultPorts = true;
      };

      caddy.virtualHosts.myDomain.extraConfig = lib.mkAfter ''
        handle {
            basic_auth {
                {$USER} {$HASHED_PASSWORD}
            }
            reverse_proxy http://${config.services.syncthing.guiAddress} {
                header_up Host {upstream_hostport}
            }
        }
      '';
    };
  };
}