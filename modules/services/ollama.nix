{ pkgs, ... }:
{
  # environment.systemPackages = with pkgs; [
  #   ollama-cuda
  # ];
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
