{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    nh
    testdisk-qt
    p7zip
    nil         # LSP for Kate editor
    nixd        # LSP for zed
  ];
}
