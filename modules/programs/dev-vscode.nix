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
    environment.systemPackages = with pkgs; [
      github-desktop
      (pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = with pkgs.vscode-extensions; [
          continue.continue
          jnoortheen.nix-ide
        ];
      })
    ];
    programs.direnv.enable = true;
  };
}
