{
  lib,
  config,
  ...
}:
{
  options = {
    alvr.enable = lib.mkEnableOption "enables alvr module";
  };

  config = lib.mkIf config.alvr.enable {
    programs.alvr.enable = true;
    programs.alvr.openFirewall = true;
  };
}
