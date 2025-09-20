{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    dev.enable = lib.mkEnableOption "enables dev module";
  };

  config = lib.mkIf config.dev.enable {
    environment.systemPackages = [
      pkgs.github-desktop
      pkgs.zed-editor
    ];
  };
}
