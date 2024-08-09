{ pkgs, inputs, ... }:
{
  stylix.enable = false;
  stylix.image = "${inputs.background-img}";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/darkmoss.yaml";
}
