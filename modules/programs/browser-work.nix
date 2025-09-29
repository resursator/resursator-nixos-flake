{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    browser-work.enable = lib.mkEnableOption "enables browser-work module";
  };

  config = lib.mkIf config.browser-work.enable {
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
      google-chrome
    ];
  };
}
