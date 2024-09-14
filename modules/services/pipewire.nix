{
  lib,
  config,
  ...
}:
{
  options = {
    pipewire.enable =
      lib.mkEnableOption "enables pulse module";
  };
  config = lib.mkIf config.pipewire.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig.pipewire."92-crackling" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.allowed-rates = [ 48000 ];
          default.clock.quantum = 1024;
          default.clock.min-quantum = 1024;
          default.clock.max-quantum = 2048;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };
  };
}
