{
  lib,
  config,
  pkgs,
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
      environmentVariables = {
        CUDA_VISIBLE_DEVICES = "0";
        LD_LIBRARY_PATH = "${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudatoolkit}/lib64";
      };
    };
    networking.firewall.allowedTCPPorts = [ 11434 ];
  };
}
