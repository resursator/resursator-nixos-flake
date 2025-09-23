{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nextcloud-client.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables nextcloud-client module";
  };

  config = lib.mkIf (lib.hasAttr "nextcloud-client" config && config.nextcloud-client.enable) {
    home.packages = with pkgs; [
      nextcloud-client
    ];
  };
}
