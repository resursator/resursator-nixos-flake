{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    keypassxc.enable = lib.mkEnableOption "enables keypassxc module";
  };

  config = lib.mkIf config.keypassxc.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
