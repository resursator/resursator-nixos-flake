{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    browser.enable = lib.mkEnableOption "enables browser module";
  };

  config = lib.mkIf config.browser.enable {
    environment.systemPackages = with pkgs; [
      librewolf
    ];
  };
}
