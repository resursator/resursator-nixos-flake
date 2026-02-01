{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    restic-rclone.enable = lib.mkEnableOption "enables restic-rclone module";
  };

  config = lib.mkIf config.restic-rclone.enable {
    environment.systemPackages = with pkgs; [
      restic
      rclone
    ];
  };
}
