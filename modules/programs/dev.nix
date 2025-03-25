{
  lib,
  config,
  pkgs,
  zedpkgs,
  ...
}:
{
  options = {
    dev.enable = lib.mkEnableOption "enables dev module";
  };

  config = lib.mkIf config.dev.enable {
    environment.systemPackages = [
      pkgs.git
      pkgs.github-desktop
      zedpkgs.zed-editor
    ];
  };
}
