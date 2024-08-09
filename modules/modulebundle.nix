{ ... }:
{
  imports = [
    ./programs/browser.nix
    ./programs/dev.nix
    ./programs/messengers.nix
    ./programs/steam.nix
    ./services/openrgb.nix
    ./services/ssh.nix
    ./utils/cli.nix
    ./utils/gui.nix
  ];
}
