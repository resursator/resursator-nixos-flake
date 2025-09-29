{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    dev-vscode.enable = lib.mkEnableOption "enables dev-vscode module";
  };

  config = lib.mkIf config.dev-vscode.enable {
    environment.systemPackages = [
      pkgs.github-desktop
      pkgs.vscode
    ];
    programs.direnv.enable = true;
  };
}
