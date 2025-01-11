{ config, lib, ... }:

{
  options.synced.sing-box-inbounds = lib.mkOption {
    default = "${config.synced.configDir}/sing-box-inbounds.json";
    type = lib.types.path;
  };

  config ={
    programs.rust-motd.settings.service_status.sing-box = "sing-box";
    services.sing-box = {
      enable = true;
      settings = {
        inbounds = {
          _secret = config.synced.sing-box-inbounds;
          quote = false;
        };
      };
    };
  };
}