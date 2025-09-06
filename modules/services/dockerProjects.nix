{
  lib,
  config,
  pkgs,
  ...
}:
let
  mkService = project: composeFile: {
    "${project}" = {
      description = "Docker Compose Service for ${project}";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.docker}/bin/docker compose -f ${composeFile} up";
        ExecStop = "${pkgs.docker}/bin/docker compose -f ${composeFile} down";
        Restart = "always";
      };
    };
  };

  mkDirs = project: [
    "d /var/lib/dockerProjects/${project} 0755 root root -"
    "d /var/lib/dockerProjects/${project}/data 0755 root root -"
  ];
in
{
  options.dockerProjects = {
    enable = lib.mkEnableOption "Enable dockerProjects module";
    projects = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {
        portainer = ../docker-compose/portainer/docker-compose.yml;
      };
      description = "Set of docker-compose projects (name -> path to yml)";
    };
  };

  config = lib.mkIf config.dockerProjects.enable (
    let
      projects = builtins.attrNames config.dockerProjects.projects;
      services = lib.foldl' (
        acc: project: acc // mkService project (config.dockerProjects.projects.${project})
      ) { } projects;
    in
    {
      systemd.tmpfiles.rules = lib.concatMap mkDirs projects;
      systemd.services = services;
    }
  );
}
