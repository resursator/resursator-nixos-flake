{ lib, config, ... }:
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
    };
  };
}
