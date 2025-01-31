{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    amnezia.enable = lib.mkEnableOption "enables amnezia module";
  };

  config = lib.mkIf config.amnezia.enable {
    environment.systemPackages = with pkgs; [
      amnezia-vpn
    ];
  };
}
