{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    tor-browser.enable = lib.mkEnableOption "enables tor-browser module";
  };

  config = lib.mkIf config.tor-browser.enable {
    environment.systemPackages = with pkgs; [
      tor-browser
    ];
  };
}
