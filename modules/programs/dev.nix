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
    environment.systemPackages = with pkgs; [
      git
      github-desktop
      zed-editor
    ];
  };
}
