{
  lib,
  config,
  ...
}:
{
  options = {
    template.enable = lib.mkEnableOption "enables template module";
  };

  config = lib.mkIf config.template.enable {

  };
}
