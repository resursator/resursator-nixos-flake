{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    nextcloud-client.enable = lib.mkEnableOption "enables nextcloud-client module";
  };

  config = lib.mkIf config.nextcloud-client.enable {
    environment.systemPackages = with pkgs; [
      nextcloud-client
    ];
  };
}
