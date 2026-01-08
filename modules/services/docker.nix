{
  lib,
  config,
  ...
}:
{
  options = {
    docker.enable = lib.mkEnableOption "enables docker module";
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.extraOptions = ''
      --bip=172.31.0.1/16
    '';
    virtualisation.docker.daemon.settings = {
      registry-mirrors = [
        "https://mirror.gcr.io"
        "https://dockerproxy.com"
        "https://docker.mirrors.sjtug.sjtu.edu.cn"
      ];
    };
    users.users.resursator.extraGroups = [ "docker" ];
  };
}
