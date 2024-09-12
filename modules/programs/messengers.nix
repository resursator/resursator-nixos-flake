{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    messengers.enable = lib.mkEnableOption "enables messengers module";
  };

  config = lib.mkIf config.messengers.enable {
    environment.systemPackages = with pkgs; [
      vesktop
      telegram-desktop
    ];
  };
}
