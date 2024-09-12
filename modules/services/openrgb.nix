{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    openrgb.enable = lib.mkEnableOption "enables openrgb module";
  };

  config = lib.mkIf config.openrgb.enable {
    environment.systemPackages = with pkgs; [
      openrgb
    ];

    services.hardware.openrgb.enable = true;
    systemd.services.setGreenLight = {
      enable = true;
      description = "Setting of rgb lightning";
      after = [ "openrgb.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.openrgb}/bin/openrgb --profile /home/resursator/.config/OpenRGB/auto-yellowgreen.orp";
      };
    };

    powerManagement.resumeCommands = ''
      systemctl start setGreenLight.service
    '';
  };
}
