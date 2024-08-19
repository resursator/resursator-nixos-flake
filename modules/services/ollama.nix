{ ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host = "0.0.0.0";
  };
  networking.firewall.allowedTCPPorts = [ 11434 ];
}
