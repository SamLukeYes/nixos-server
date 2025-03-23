{
  imports = [
    ./motd.nix
    ./nix.nix
    ./xonsh.nix
  ];

  programs = {
    bat.enable = true;
    git.enable = true;
  };
}