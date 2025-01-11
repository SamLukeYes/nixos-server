{
  imports = [
    ./motd.nix
    ./nix.nix
  ];

  programs = {
    git.enable = true;
    xonsh.enable = true;
  };
}