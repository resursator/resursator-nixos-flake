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

  # programs
  alvr.enable = true;
  browser.enable = true;
  dev.enable = true;
  messengers.enable = true;
  steam.enable = true;

  # services
  ollama.enable = true;
  openrgb.enable = true;
  pipewire.enable = true;
  plymouth.enable = true;
  pulse.enable = false;
  ssh.enable = true;

  #utils
  cliutils.enable = true;
  guiutils.enable = true;

  environment.sessionVariables = {
    FLAKE = "/home/resursator/nixosFlake";
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../resources/tyler-van-der-hoeven-_ok8uVzL2gI-unsplash.jpg}
    '')
  ];
}
