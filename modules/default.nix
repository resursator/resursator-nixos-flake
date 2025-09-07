{
  pkgs,
  inputs,
  HOSTNAME,
  USERNAME,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs HOSTNAME USERNAME;
    };
    users.${USERNAME} = lib.mkMerge [
      (import ./nixos/home.nix)
      (import ./services/ssh-gpg.nix)
    ];
  };

  imports = [
    ./modulebundle.nix
    inputs.home-manager.nixosModules.default
  ];

  amd-drivers.enable = lib.mkDefault false;
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
  dockerProjects.enable = lib.mkDefault false;
  dockerProjects.projects = {
    portainer = ./docker-compose/portainer/docker-compose.yml;
  };

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
    FLAKE = "/home/${USERNAME}/nixosFlake";
    NH_FLAKE = "/home/${USERNAME}/nixosFlake";
  };

  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../resources/tyler-van-der-hoeven-_ok8uVzL2gI-unsplash.jpg}
    '')
  ];
}
