{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."resursator" = import ./nixos/home.nix;
  };

  imports = [
    ./modulebundle.nix
    inputs.home-manager.nixosModules.default
  ];

  nvidia-drivers.enable = lib.mkDefault true;

  # programs
  alvr.enable = lib.mkDefault false;
  browser.enable = lib.mkDefault true;
  dev.enable = lib.mkDefault false;
  gimp-rc.enable = lib.mkDefault false;
  messengers.enable = lib.mkDefault false;
  steam.enable = lib.mkDefault false;
  vesktopCustom.enable = lib.mkDefault false;
  zen.enable = lib.mkDefault true;

  # services
  amnezia.enable = lib.mkDefault false;
  docker.enable = lib.mkDefault true;
  ollama.enable = lib.mkDefault false;
  openrgb.enable = lib.mkDefault true;
  plymouth.enable = lib.mkDefault true;
  rustdesk.enable = lib.mkDefault true;
  ssh.enable = lib.mkDefault true;

  # sound
  pipewire.enable = lib.mkDefault true;
  pulse.enable = lib.mkDefault false;

  # utils
  cliutils.enable = lib.mkDefault true;
  guiutils.enable = lib.mkDefault true;

  environment.sessionVariables = {
    FLAKE = "/home/resursator/nixosFlake";
    NH_FLAKE = "/home/resursator/nixosFlake";
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../resources/tyler-van-der-hoeven-_ok8uVzL2gI-unsplash.jpg}
    '')
  ];
}
