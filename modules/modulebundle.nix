{ ... }:
{
  imports = [
    ./programs/alvr.nix
    ./programs/browser.nix
    ./programs/dev.nix
    ./programs/gimp-rc.nix
    ./programs/messengers.nix
    ./programs/rustdesk.nix
    ./programs/steam.nix
    ./programs/vesktopCustom.nix
    ./services/amnezia.nix
    ./services/docker.nix
    ./services/ollama.nix
    ./services/openrgb.nix
    ./services/pipewire.nix
    ./services/pulse.nix
    ./services/plymouth.nix
    ./services/ssh.nix
    ./utils/cli.nix
    ./utils/gui.nix
  ];
}
