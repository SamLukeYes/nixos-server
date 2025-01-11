{ config, lib, ... }:

{
  imports = [
    ./caddy.nix
    ./sing-box.nix
  ];

  options.synced.configDir = lib.mkOption {
    default = "${config.services.syncthing.dataDir}/Sync";
    type = lib.types.path;
    description = "Directory of config files managed by Syncthing.";
  };

  config = {
    programs.rust-motd.settings.service_status.syncthing = "syncthing";
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
    };
  };
}