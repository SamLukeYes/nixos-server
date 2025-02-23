{ ... }:

{
  programs.rust-motd.settings.service_status.cloudflare-warp = "cloudflare-warp";

  services.cloudflare-warp.enable = true;
}