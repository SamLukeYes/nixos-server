{
  imports = [
    ./motd.nix
    ./nix.nix
    ./xonsh.nix
  ];

  programs.git.enable = true;
}