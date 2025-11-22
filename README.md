# My NixOS configurations for VPS

Steps to add a new server:

1. Install Nix on target host and add substituters to `/etc/nix/nix.conf`

2. Add a new configuration to this repo based on `nixos-generate-config` result on target host, with ssh and public keys configured

3. Create `/etc/NIXOS` and `/etc/NIXOS_LUSTRATE` on target host

4. Run `sudo mkdir /boot.bak && sudo mv /boot/* /boot.bak` on target host

5. `nixos-rebuild boot --flake '.#<new_server>' --target-host <new_server> --substitute-on-destination`

6. Reboot target host

7. Remove target host from `~/.ssh/known_hosts`, because its keys are regenerated

8. Reset root password for target host

9. Use SSH port forwarding to configure Syncthing for the first time

```sh
ssh -L 18384:127.0.0.1:8384 <new_server> -N
```

10. Set up Cloudflare Warp

```sh
warp-cli registration new
warp-cli mode proxy
warp-cli connect
```

11. Set up swap file and redeploy
