{ config, lib, pkgs, inputs, options, ... }:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."resursator" = import ./nixos/home.nix;
  };
  imports = [
    ./modulebundle.nix
    inputs.home-manager.nixosModules.default
  ];
  environment.sessionVariables = {
    FLAKE = "/home/resursator/nixosFlake";
  };
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${inputs.background-img}
    '')
  ];
}
