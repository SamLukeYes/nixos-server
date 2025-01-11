{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      
      # https://gist.github.com/ssrlive/32d4f2796746cd5e751985be19adf7a1
      AllowTcpForwarding = "yes";
      GatewayPorts = "yes";
    };
  };
}