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
      (import ./home-manager-modules/home.nix)
      (import ./home-manager-modules/nextcloud-client-nh.nix)
      (import ./home-manager-modules/ssh-gpg.nix)
      (import ./home-manager-modules/ssh-keys.nix)
    ];
  };

  imports = [
    ./modulebundle.nix
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [
        inputs.plasma-manager.homeModules.plasma-manager
        inputs.sops-nix.homeManagerModules.sops
      ];
    }
  ];

  amd-drivers.enable = lib.mkDefault false;
  nvidia-drivers.enable = lib.mkDefault true;

  # programs
  _3d.enable = lib.mkDefault false;
  alvr.enable = lib.mkDefault false;
  browser.enable = lib.mkDefault true;
  browser-work.enable = lib.mkDefault false;
  dev.enable = lib.mkDefault false;
  dev-vscode.enable = lib.mkDefault false;
  fjord-launcher.enable = lib.mkDefault false;
  gimp-rc.enable = lib.mkDefault false;
  keypassxc.enable = lib.mkDefault false;
  kodi-iptv.enable = lib.mkDefault false;
  libreoffice.enable = lib.mkDefault false;
  messengers-work.enable = lib.mkDefault false;
  messengers.enable = lib.mkDefault false;
  nextcloud-client.enable = lib.mkDefault false;
  obsidian.enable = lib.mkDefault false;
  pdf-utils.enable = lib.mkDefault false;
  rclone.enable = lib.mkDefault false;
  steam.enable = lib.mkDefault false;
  tor-browser.enable = lib.mkDefault false;
  vesktopCustom.enable = lib.mkDefault false;
  zen.enable = lib.mkDefault true;

  # services
  amnezia.enable = lib.mkDefault false;
  docker.enable = lib.mkDefault true;
  dockerProjects.enable = lib.mkDefault false;
  dockerProjects.projects = {
    # portainer = ./docker-compose/portainer/docker-compose.yml;
  };
  k8t-kind.enable = lib.mkDefault false;

  ollama.enable = lib.mkDefault false;
  openrgb.enable = lib.mkDefault true;
  plymouth.enable = lib.mkDefault true;
  rustdesk.enable = lib.mkDefault false;
  restic-rclone.enable = lib.mkDefault false;
  sops.enable = lib.mkDefault true;
  ssh.enable = lib.mkDefault true;
  wireguard-transit.enable = lib.mkDefault false;
  x11vnc.enable = lib.mkDefault false;
  yggdrasil.enable = lib.mkDefault false;
  zerotier.enable = lib.mkDefault false;

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
