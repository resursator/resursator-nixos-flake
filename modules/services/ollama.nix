{
  lib,
  config,
  ...
}:
{
  options = {
    ollama.enable = lib.mkEnableOption "enables ollama module";
  };

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
      host = "0.0.0.0";
    };
    networking.firewall.allowedTCPPorts = [ 11434 ];
  };
}
