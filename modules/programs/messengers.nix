{
  lib,
  config,
  pkgs,
  ...
}:
let
  telegramWrapper =
    pkgs.runCommand "telegram-desktop-wrapper"
      {
        buildInputs = [ pkgs.telegram-desktop ];
      }
      ''
        mkdir -p $out/bin
        cat > $out/bin/telegram <<'EOF'
        #!${pkgs.stdenv.shell}
        export QT_LOGGING_RULES="qt.gui.imageio.*=false;ffmpeg.*=false"
        exec ${pkgs.telegram-desktop}/bin/Telegram "$@"
        EOF
        chmod +x $out/bin/telegram
      '';
in
{
  options = {
    messengers.enable = lib.mkEnableOption "enables messengers module";
  };

  config = lib.mkIf config.messengers.enable {
    environment.systemPackages = [
      telegramWrapper
    ];
  };
}
