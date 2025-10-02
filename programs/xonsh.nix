{ config, ... }:

{
  programs.xonsh = {
    enable = true;
    config = ''
      $XONSH_COLOR_STYLE = 'native'
    '';
  };

  users.defaultUserShell = config.programs.xonsh.package;
}