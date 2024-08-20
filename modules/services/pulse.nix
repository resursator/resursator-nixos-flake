{ lib, config, ... }:
{
  options = {
    pulse.enable =
      lib.mkEnableOption "enables pulse module";
  };

  config = lib.mkIf config.pulse.enable {
    hardware.pulseaudio.enable = true;
  };
}
