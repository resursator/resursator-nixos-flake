{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    rustdesk.enable = lib.mkEnableOption "enables rustdesk module";
  };

  config = lib.mkIf config.rustdesk.enable {
    environment.systemPackages = with pkgs; [
      rustdesk
    ];
    systemd.services.rustdesk = {
      enable = true;
      description = "rustdesk";
      serviceConfig = {
        ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
        ExecStop = "pkill -f \"rustdesk --\"";
        PIDFile = "/run/rustdesk.pid";
        KillMode = "mixed";
        TimeoutStopSec = "30";
        User = "root";
        LimitNOFILE = "100000";
      };
      wantedBy = [ "multi-user.target" ];
      requires = ["network-online.target"];
      after = ["display-manager.service"];
    };
  };
}
