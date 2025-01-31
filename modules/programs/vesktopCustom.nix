{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    vesktopCustom.enable = lib.mkEnableOption "enables vesktop with custom icon";
  };

  config = lib.mkIf config.vesktopCustom.enable {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
