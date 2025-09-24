{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    obsidian.enable = lib.mkEnableOption "enables obsidian module";
  };

  config = lib.mkIf config.obsidian.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
