{ config, ... }:

{
  programs.xonsh.enable = true;
  users.defaultUserShell = config.programs.xonsh.package;
}