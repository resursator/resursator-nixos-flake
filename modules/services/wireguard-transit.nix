{
  lib,
  config,
  ...
}:
{
  options = {
    wireguard-transit.enable = lib.mkEnableOption "enables wireguard-transit module";
  };

  config = lib.mkIf config.wireguard-transit.enable {
    networking.wireguard = {
      enable = true;

      # === Сервер для клиентов ===
      interfaces."wg-server" = {
        ips = [ "10.10.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/server.key";
        peers = [
          {
            publicKey = "EZpz0x2KLjm9+t819g9yaiaTbeoiENV4yaay3Vjy3WE="; # home-mikrotik.pub
            allowedIPs = [ "10.10.0.2/32" ];
          }
          {
            publicKey = "B3ee4g0ga4m2o6A/+wNn7oOrbjppZHZFNZKb+J3wTlg="; # pixel-tablet.pub
            allowedIPs = [ "10.10.0.3/32" ];
          }
        ];
      };

      # === Клиент до внешнего VPN (апстрим) ===
      interfaces."wg-client" = {
        ips = [ "10.13.13.4/32" ];
        privateKeyFile = "/etc/wireguard/client.key";
        peers = [
          {
            publicKey = "UKXehTcON8rZ0Ldt/iDuCnXSBZVkp7gSAylQKn8U/x4=";
            endpoint = "placeholder";
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            persistentKeepalive = 25;
          }
        ];
      };
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ "wg-server" ];
      externalInterface = "wg-client";
    };

    networking.firewall = {
      enable = true;
      allowedUDPPorts = [ 51820 ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

  };
}
