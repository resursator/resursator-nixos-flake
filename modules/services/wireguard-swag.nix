{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    wireguard-swag.enable = lib.mkEnableOption "enables wireguard-swag module";
  };
  config = lib.mkIf config.wireguard-swag.enable {
    environment.systemPackages = with pkgs; [
      amneziawg-go
      amneziawg-tools
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      amneziawg
    ];
    boot.kernelModules = [ "amneziawg" ];

    systemd.services."awg-quick@awg0" = {
      description = "AmneziaWG via awg-quick for awg0";
      after = [ "network-online.target" "nss-lookup.target" "sys-module-amneziawg.device" ];
      wants = [ "network-online.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up /etc/amnwireguard/awg0.conf";
        ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down /etc/amnwireguard/awg0.conf";
      };
    };
  };
}
