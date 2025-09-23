{
  lib,
  config,
  ...
}:
{
  options.template_hm.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables template_hm module";
  };

  config = lib.mkIf (lib.hasAttr "template_hm" config && config.template_hm.enable) {

  };
}
