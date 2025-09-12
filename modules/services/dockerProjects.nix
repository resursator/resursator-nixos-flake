{
  lib,
  config,
  pkgs,
  ...
}:
let
  mkService =
    project: composeFile:
    let
      projectDir = "/var/lib/dockerProjects/${project}";
      composeCopy = "${projectDir}/docker-compose.yml";
    in
    {
      "${project}" = {
        description = "Docker Compose Service for ${project}";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker compose -f ${composeCopy} up";
          ExecStop = "${pkgs.docker}/bin/docker compose -f ${composeCopy} down";
          Restart = "always";
          WorkingDirectory = projectDir;
        };
      };
    };

  mkTmpfiles =
    project: composeFile:
    let
      projectDir = "/var/lib/dockerProjects/${project}";
    in
    [
      "d ${projectDir} 0755 root root -"
      "d ${projectDir}/data 0755 root root -"
      "L+ ${projectDir}/docker-compose.yml - - - - ${composeFile}"
    ];
in
{
  options.dockerProjects = {
    enable = lib.mkEnableOption "Enable dockerProjects module";
    projects = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {
        portainer = ../docker-compose/portainer-local/docker-compose-local.yml;
      };
      description = "Set of docker-compose projects (name -> path to yml)";
    };
  };

  config = lib.mkIf config.dockerProjects.enable (
    let
      projects = builtins.attrNames config.dockerProjects.projects;
      services = lib.genAttrs projects (
        project: mkService project (config.dockerProjects.projects.${project})
      );
      tmpfiles = lib.concatMap (
        project: mkTmpfiles project (config.dockerProjects.projects.${project})
      ) projects;
    in
    {
      systemd.services = lib.mkMerge (builtins.attrValues services);
      systemd.tmpfiles.rules = tmpfiles;
    }
  );
}
