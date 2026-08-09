{ ... }:

{
  preservation = {
    enable = true;
    preserveAt = {
      "/old-root" = {
        directories = [
          { directory = "/nix"; inInitrd = true; }
        ];
      };
      "/old-root/nixos" = {
        directories = [
          { directory = "/etc"; inInitrd = true; }
          { directory = "/var"; inInitrd = true; }
          "/root"
        ];
      };
    };
  };

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "size=90%" "mode=755" ];
  };

  # TODO: actually make dual boot work
  boot.loader.grub.useOSProber = true;
}
