{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nh
    nil         # LSP for Kate editor
    nixd        # LSP for zed
    p7zip
    rar
    testdisk-qt
    wget
  ];
}
