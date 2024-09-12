{
  lib,
  config,
  ...
}:
{
  options = {
    pulse.enable =
      lib.mkEnableOption "enables pulse module";
  };

  config = lib.mkIf config.pulse.enable {
    services.pipewire.enable = false;
    hardware.pulseaudio.enable = true;
  };
}
