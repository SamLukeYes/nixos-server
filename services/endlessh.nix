{ ... }:

# Use this on any machine without an external firewall,
# and set real ssh port to another value.

{
  programs.rust-motd.settings.service_status.endlessh-go = "endlessh-go";

  services.endlessh-go = {
    enable = true;
    port = 22;
    openFirewall = true;
    extraOptions = [
      "-v=1"
    ];
  };
}