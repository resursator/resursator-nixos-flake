{
  config,
  lib,
  ...
}:
{
  options = {
    amd-drivers.enable = lib.mkEnableOption "enables amd drivers module";
  };

  config = lib.mkIf config.amd-drivers.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics.enable = true;
  };
}
