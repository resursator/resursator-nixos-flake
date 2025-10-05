{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    zerotier.enable = lib.mkEnableOption "enables zerotier module";
  };

  config = lib.mkIf config.zerotier.enable {
    environment.systemPackages = [
      pkgs.zerotierone
    ];

    services.zerotierone = {
      enable = true;
      joinNetworks = [];
    };
  };
}
