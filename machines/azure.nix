{ config, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/azure-common.nix"
    "${modulesPath}/virtualisation/azure-image.nix"
  ];

  nix.settings.trusted-users = [ "azureuser" ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 2 * 1024;
  }];

  synced.caddy-secret-file = "${config.synced.configDir}/caddy/azure.env";

  system.stateVersion = "24.11";

  # https://github.com/NixOS/nixpkgs/pull/359365#issuecomment-2564689870
  virtualisation.azure.acceleratedNetworking = true;
}