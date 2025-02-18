{
  lib,
  config,
  zenpkgs,
  ...
}:
{
  options = {
    zen.enable = lib.mkEnableOption "enables zen beta module";
  };

  config = lib.mkIf config.zen.enable {
    environment.systemPackages = with zenpkgs; [
      default
    ];
  };
}
