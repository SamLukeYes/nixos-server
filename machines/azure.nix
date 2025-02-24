{ config, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
  ];

  nix.settings.trusted-users = [ "azureuser" ];

  programs.rust-motd.settings = {
    last_login.azureuser = 5;
    service_status.waagent = "waagent";
  };

  # https://github.com/NixOS/nixpkgs/pull/362101#issuecomment-2602406516
  services.waagent.settings.OS.OpensslPath = "${pkgs.openssl}/bin/openssl";

  swapDevices = [{
    device = "/var/swapfile";
    size = 2 * 1024;
  }];

  synced.caddy-secret-file = "${config.synced.configDir}/caddy/azure.env";

  # https://github.com/NixOS/nixpkgs/pull/359365#issuecomment-2564689870
  virtualisation.azure.acceleratedNetworking = true;
}