{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    gimp-rc.enable = lib.mkEnableOption "enables gimp 3.0 rc module";
  };

  config = lib.mkIf config.gimp-rc.enable {
    environment.systemPackages = with pkgs; [
      gimp3
    ];
  };
}
