{ ... }:

{
  programs.pacman = {
    autoSync.enable = true;
    conf.extraConfig = ''
      [options]
      Color
      ILoveCandy

      [archlinuxcn]
      Server = https://repo.archlinuxcn.org/$arch
    '';
  };
}