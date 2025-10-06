{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfgDir = "/etc";
  cfgFile = "${cfgDir}/yggdrasil.conf";

  YGG_PEERS = [
    "tcp://ygg-msk-1.averyan.ru:8363"
    "tls://ygg-msk-1.averyan.ru:8362"
    "quic://ygg-msk-1.averyan.ru:8364"
    "tcp://yggno.de:18226"
    "tls://yggno.de:18227"
    "tcp://188.225.9.167:18226"
    "tls://188.225.9.167:18227"
    "tcp://x-mow-0.sergeysedoy97.ru:65533"
    "tcp://s-mow-0.sergeysedoy97.ru:65533"
    "tls://x-mow-0.sergeysedoy97.ru:65534"
    "tls://s-mow-0.sergeysedoy97.ru:65534"
    "quic://x-mow-0.sergeysedoy97.ru:65535"
    "tcp://x-mow-1.sergeysedoy97.ru:65533"
    "tcp://s-mow-1.sergeysedoy97.ru:65533"
    "tls://x-mow-1.sergeysedoy97.ru:65534"
    "tls://s-mow-1.sergeysedoy97.ru:65534"
    "quic://x-mow-1.sergeysedoy97.ru:65535"
    "tcp://45.147.200.202:12402"
    "tcp://[2a00:b700::a:279]:12402"
    "tls://45.147.200.202:443"
    "tls://[2a00:b700::a:279]:443"
    "tcp://45.95.202.21:12403"
    "tcp://[2a09:5302:ffff::992]:12403"
    "tls://45.95.202.21:443"
    "tls://[2a09:5302:ffff::992]:443"
    "tcp://ip4.01.msk.ru.dioni.su:9002"
    "tls://ip4.01.msk.ru.dioni.su:9003"
    "quic://ip4.01.msk.ru.dioni.su:9002"
    "ws://ip4.01.msk.ru.dioni.su:9004"
    "tcp://ip6.01.msk.ru.dioni.su:9002"
    "tls://ip6.01.msk.ru.dioni.su:9003"
    "quic://ip6.01.msk.ru.dioni.su:9002"
    "ws://ip6.01.msk.ru.dioni.su:9004"
    "tcp://yggdrasil.1337.moe:7676"
    "tcp://msk1.neonxp.ru:7991"
    "tcp://195.2.74.155:7991"
    "tls://msk1.neonxp.ru:7992"
    "tls://195.2.74.155:7992"
    "ws://msk1.neonxp.ru:7993"
    "ws://195.2.74.155:7993"
    "quic://msk1.neonxp.ru:7994"
    "quic://195.2.74.155:7994"
    "tcp://box.paulll.cc:13337"
    "tls://box.paulll.cc:13338"
    "tcp://91.220.109.93:8080"
    "tcp://srv.itrus.su:7991"
    "tls://srv.itrus.su:7992"
    "quic://srv.itrus.su:7993"
    "ws://srv.itrus.su:7994"
    "tcp://37.192.232.33:8080"
    "tls://37.192.232.33:442"
    "tcp://itcom.multed.com:7991"
    "tcp://ekb.itrus.su:7991"
    "tls://ekb.itrus.su:7992"
    "quic://ekb.itrus.su:7993"
    "ws://ekb.itrus.su:7994"
    "tcp://ip4.01.ekb.ru.dioni.su:9002"
    "tls://ip4.01.ekb.ru.dioni.su:9003"
    "quic://ip4.01.ekb.ru.dioni.su:9002"
    "ws://ip4.01.ekb.ru.dioni.su:9004"
    "tcp://ip6.01.ekb.ru.dioni.su:9002"
    "tls://ip6.01.ekb.ru.dioni.su:9003"
    "quic://ip6.01.ekb.ru.dioni.su:9002"
    "ws://ip6.01.ekb.ru.dioni.su:9004"
    "tls://vix.duckdns.org:36014"
    "quic://vix.duckdns.org:36014"
    "tcp://ip4.01.tom.ru.dioni.su:9002"
    "tls://ip4.01.tom.ru.dioni.su:9003"
    "quic://ip4.01.tom.ru.dioni.su:9002"
    "ws://ip4.01.tom.ru.dioni.su:9004"
    "tcp://kzn1.neonxp.ru:7991"
    "tcp://195.58.51.167:7991"
    "tls://kzn1.neonxp.ru:7992"
    "tls://195.58.51.167:7992"
    "ws://kzn1.neonxp.ru:7993"
    "ws://195.58.51.167:7993"
    "quic://kzn1.neonxp.ru:7994"
    "quic://195.58.51.167:7994"
    "tls://kursk.cleverfox.org:15015"
    "quic://kursk.cleverfox.org:15015"
    "ws://kursk.cleverfox.org:15016"
    "tcp://yg-vvo.magicum.net:29330"
    "tls://yg-vvo.magicum.net:29331"
    "tcp://185.165.169.234:8880"
    "tls://185.165.169.234:8443"
    "tcp://45.137.99.182:1337"
    "tls://ygg.mkg20001.io:443"
    "tcp://ygg.mkg20001.io:80"
    "tcp://ygg1.mk16.de:1337?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
    "tls://ygg1.mk16.de:1338?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
    "tcp://ygg2.mk16.de:1337?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"
    "tls://ygg2.mk16.de:1338?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"
    "tls://vpn.ltha.de:443?key=0000006149970f245e6cec43664bce203f2514b60a153e194f31e2b229a1339d"
    "tls://de-fsn-1.peer.v4.yggdrasil.chaz6.com:4444"
    "tcp://yggdrasil.su:62486"
    "tls://yggdrasil.su:62586"
    "tls://mlupo.duckdns.org:9001"
    "tcp://x-fra-0.sergeysedoy97.ru:65533"
    "tcp://s-fra-0.sergeysedoy97.ru:65533"
    "tls://x-fra-0.sergeysedoy97.ru:65534"
    "tls://s-fra-0.sergeysedoy97.ru:65534"
    "quic://x-fra-0.sergeysedoy97.ru:65535"
    "tcp://ip4.fvm.mywire.org:8080?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
    "quic://ip4.fvm.mywire.org:443?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
    "tcp://ip6.fvm.mywire.org:8080?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
    "quic://ip6.fvm.mywire.org:443?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
    "tls://helium.avevad.com:1337"
    "tls://yggdrasil.neilalexander.dev:64648?key=ecbbcb3298e7d3b4196103333c3e839cfe47a6ca47602b94a6d596683f6bb358"
    "tcp://bode.theender.net:42069"
    "tls://bode.theender.net:42169?key=f91b909f43829f8b20732b3bcf80cbc4bb078dd47b41638379a078e35984c9a4"
    "quic://bode.theender.net:42269"
    "tls://n.ygg.yt:443"
    "tls://b.ygg.yt:443"
    "tls://g.ygg.yt:443"
  ];

  YGG_PEERS_LINE = lib.concatStringsSep ", " (map (p: "\\\"${p}\\\"") YGG_PEERS);
in
{
  options = {
    yggdrasil.enable = lib.mkEnableOption "enables yggdrasil module";
  };

  config = lib.mkIf config.yggdrasil.enable {
    environment.systemPackages = [
      pkgs.yggdrasil
    ];

    systemd.services.yggdrasil = {
      description = "Yggdrasil IPv6 mesh network daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.yggdrasil}/bin/yggdrasil -useconffile ${cfgFile}";
        Restart = "on-failure";
        Type = "simple";
        RuntimeDirectory = "yggdrasil";
        RuntimeDirectoryMode = "0755";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
      };
    };

    system.activationScripts.yggdrasil-config = {
      text = ''
        if [ ! -f ${cfgFile} ]; then
          echo "Generating Yggdrasil config at ${cfgFile}..."
          ${pkgs.yggdrasil}/bin/yggdrasil -genconf > ${cfgFile}
        fi

        ${pkgs.gnused}/bin/sed -i 's|"IfMTU":.*|"IfMTU": 1280,|' ${cfgFile}

        ${pkgs.gnused}/bin/sed -i "s|^[[:space:]]*Peers:.*|Peers: [ ${YGG_PEERS_LINE} ]|" ${cfgFile}
      '';
    };
  };
}
