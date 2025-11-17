{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    k8t-kind.enable = lib.mkEnableOption "enables k8t-kind module";
  };

  config = lib.mkIf config.k8t-kind.enable {
    environment.systemPackages = with pkgs; [
      kubernetes-helm
      kind
      kubectl
      kubernetes-helm
      lens
    ];
  };
}
