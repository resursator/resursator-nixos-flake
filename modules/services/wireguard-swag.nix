{
  lib,
  config,
  ...
}:
{
  options = {
    wireguard-swag.enable = lib.mkEnableOption "enables wireguard-swag module";
  };

  config = lib.mkIf config.wireguard-swag.enable {

    networking.wireguard.interfaces.wg0 = {
      ips = [ "10.8.0.2/24" ];

      privateKeyFile = "/etc/wireguard/wg0.key";

      peers = [
        {
          publicKey = "uhOgraC20g+n4Xw2DxTvI5XKQkT3/sx+OR34x4pxYU8=";
          endpoint = "132.243.26.120:51820";
          allowedIPs = [ "10.8.0.1/32" ];
          persistentKeepalive = 25;
        }
      ];
    };

  };
}
