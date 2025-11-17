{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    amnezia.enable = lib.mkEnableOption "enables amnezia module";
  };

  config = lib.mkIf config.amnezia.enable {
    environment.systemPackages = with pkgs; [
      amnezia-vpn
    ];

    # Основной сервис
    systemd.services.amnezia-vpn = {
      enable = true;
      description = "Amnezia VPN client service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.amnezia-vpn}/bin/AmneziaVPN-service";
        ExecStop = "${pkgs.coreutils}/bin/killall AmneziaVPN-service";
        Restart = "on-failure";
      };
    };

    # Хуки suspend/resume
    systemd.services."amnezia-vpn-sleep" = {
      description = "Stop/Start AmneziaVPN on sleep/resume";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];

      # Два отдельных Exec...: NixOS умеет
      serviceConfig = {
        Type = "oneshot";

        # При входе в сон
        ExecStart = "/run/current-system/systemd/bin/systemctl stop amnezia-vpn.service";

        # При выходе из сна
        ExecStop = "/run/current-system/systemd/bin/systemctl start amnezia-vpn.service";
      };
    };
  };
}
