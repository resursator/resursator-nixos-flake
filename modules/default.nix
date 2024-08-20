{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."resursator" = import ./nixos/home.nix;
  };

  imports = [
    ./nixos/nvidia.nix
    ./modulebundle.nix
    inputs.home-manager.nixosModules.default
  ];

  pulse.enable = false;
  pipewire.enable = true;

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
