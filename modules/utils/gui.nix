{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    guiutils.enable = lib.mkEnableOption "enables guiutils module";
  };

  config = lib.mkIf config.guiutils.enable {
    environment.systemPackages = with pkgs; [
      bottles
      qalculate-qt
      vlc
      winbox
    ];
  };
}
