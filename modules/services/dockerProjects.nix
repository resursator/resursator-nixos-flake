{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs
    mkMerge
    ;
  dockerProjects = {
    portainer = "/home/resursator/docker/portainer";
    ntfy = "/home/resursator/docker/ntfy";
  };
in
{
  options = {
    dockerProjects.enable = mkEnableOption "Enable automatic docker-compose projects";
  };

  config = mkIf config.dockerProjects.enable {

    # Включаем docker
    services.docker.enable = true;

    # Добавляем пользователя в группу docker
    users.users.resursator.extraGroups = (config.users.users.resursator.extraGroups or [ ]) ++ [
      "docker"
    ];

    # Создаём systemd unit для каждого проекта
    systemd.services = mkMerge (
      mapAttrs (name: path: {
        "docker-compose-${name}" = {
          description = "Docker Compose project: ${name}";
          wantedBy = [ "multi-user.target" ];
          after = [ "docker.service" ];
          requires = [ "docker.service" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${path}/docker-compose.yml up -d";
            ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${path}/docker-compose.yml down";
          };
        };
      }) dockerProjects
    );
  };
}
