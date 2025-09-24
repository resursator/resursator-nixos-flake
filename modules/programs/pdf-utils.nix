{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    pdf-utils.enable = lib.mkEnableOption "enables pdf-utils module";
  };

  config = lib.mkIf config.pdf-utils.enable {
    environment.systemPackages = with pkgs; [
      imagemagick
      poppler-utils
    ];
  };
}
