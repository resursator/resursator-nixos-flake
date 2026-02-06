{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    x11vnc.enable = lib.mkEnableOption "enables x11vnc module";
  };

  config = lib.mkIf config.x11vnc.enable {
    environment.systemPackages = with pkgs; [
      x11vnc
    ];
    systemd.services.x11vnc = {
      enable = true;

      unitConfig = {
        Description = "Remote desktop service (x11vnc)";
        Requires = "graphical.target";
        After = "graphical.target";
        ConditionPathExistsGlob = "/var/run/sddm/*";
      };

      serviceConfig = {
        Type = "simple";

        ExecStartPre = "/bin/sh -c '${pkgs.systemd}/bin/systemctl set-environment SDDMXAUTH=$(${pkgs.findutils}/bin/find /var/run/sddm/ -type f)'";
        ExecStart = "${pkgs.x11vnc}/bin/x11vnc -forever -shared -nopw -display :0 -localhost -auth $SDDMXAUTH";
        ExecStop = "${pkgs.coreutils}/bin/killall x11vnc";

        Restart = "on-failure";
        RestartSec = "2s";
      };

      wantedBy = [ "graphical.target" ];
    };
  };
}
