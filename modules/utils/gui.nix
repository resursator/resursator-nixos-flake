{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bottles
    qalculate-qt
    winbox
  ];
}
