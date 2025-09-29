{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    rclone.enable = lib.mkEnableOption "enables rclone module";
  };

  config = lib.mkIf config.rclone.enable {
    environment.systemPackages = with pkgs; [
      rclone
    ];
  };
}
