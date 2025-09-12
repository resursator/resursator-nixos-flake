{
  lib,
  config,
  USERNAME,
  ...
}:

let
  mkUserService =
    project: composeFile:
    let
      projectDir = "/home/${USERNAME}/.dockerProjects/${project}";
      composeCopy = "${projectDir}/.docker-compose.yml";
    in
    {
      Unit = {
        Description = "User Docker Compose Service for ${project}";
        # Нет прямой зависимости от system docker.service в user space
      };
      Service = {
        WorkingDirectory = projectDir;
        ExecStart = "docker/bin/docker compose -f ${composeCopy} up";
        ExecStop = "docker/bin/docker compose -f ${composeCopy} down";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
in
{
  options.dockerProjects = {
    enable = lib.mkEnableOption "Enable user dockerProjects module";
    projects = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {
        portainer = ../docker-compose/portainer-local/docker-compose-local.yml;
      };
      description = "User docker compose projects (name -> path to compose.yml)";
    };
  };

  config = lib.mkIf config.dockerProjects.enable (
    let
      projects = builtins.attrNames config.dockerProjects.projects;
      services = builtins.listToAttrs (
        map (project: {
          name = "docker-${project}";
          value = mkUserService project (config.dockerProjects.projects.${project});
        }) projects
      );
      files = builtins.listToAttrs (
        map (project: {
          name = ".dockerProjects/${project}/docker-compose.yml";
          value.source = config.dockerProjects.projects.${project};
        }) projects
      );
    in
    {
      home.file = files;
      systemd.user.services = services;
    }
  );
}
