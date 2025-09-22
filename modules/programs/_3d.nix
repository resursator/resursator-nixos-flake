{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    _3d.enable = lib.mkEnableOption "enables orca, blender, and other 3D-related modules";
  };

  config = lib.mkIf config._3d.enable {
    environment.systemPackages = with pkgs; [
      blender
      freecad
      orca-slicer
    ];
  };
}
