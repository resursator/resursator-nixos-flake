{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    messengers-work.enable = lib.mkEnableOption "enables messengers-work module";
  };

  config = lib.mkIf config.messengers-work.enable {
    environment.systemPackages = with pkgs; [
      mattermost-desktop
    ];
  };
}
